import os
import re
import xml.etree.ElementTree as ET

def replace_in_file_and_create_copy(file_path):
    with open(file_path, 'r', encoding='utf-8') as file:
        content = file.read()

    patterns_replacements = [
        (r'ankabotController:', 'snowbotController:'),
        (r'\.character:', '.character():'),
        (r'\.map:', '.map():'),
        (r'\.global:', '.global():'),
        (r'\.exchange:', '.exchange():'),
        (r'\.inventory:', '.inventory():'),
        (r'\.job:', '.job():'),
        (r'\.npc:', '.npc():'),
        (r'\.sale:', '.sale():'),
        (r'\.craft:', '.craft():'),
        (r'\.chat:', '.chat():'),
        (r'\.quest:', '.quest():'),
        (r'\.mount:', '.mount():'),
        (r'\.treasure:', '.treasure():'),
        (r'\.developer:', '.developer():'),
        (r'fightAction:moveToWardCell', 'fightAction:moveTowardCell'),
        (r'objectt', 'object'),
        (r'fightManagementPosition', 'prefightManagement'),
        (r'ANKABOT_TIMEOUT', 'SNOW_TIMEOUT'),
        (r'getTypeId', 'itemTypeId'),
        (r'loadAccount', 'loadAnAccount'),
    ]

    for pattern, replacement in patterns_replacements:
        content = re.sub(pattern, replacement, content)

    content = "--This script is ready to be used on Snowbot\n" + content

    new_file_path = file_path.replace('.lua', '-Snow.lua')

    with open(new_file_path, 'w', encoding='utf-8') as new_file:
        new_file.write(content)

def process_directory(directory):
    for root, _, files in os.walk(directory):
        for file in files:
            if file.endswith('.lua') and '-Snow' not in file:  
                file_path = os.path.join(root, file)
                replace_in_file_and_create_copy(file_path)

def process_xml(file_path):
    tree = ET.parse(file_path)
    root = tree.getroot()

    array1 = root.findall('ArrayOfString')[0]
    array2 = root.findall('ArrayOfString')[1]

    if len(array1) != len(array2):
        raise ValueError("Arrays of different lengths")

    result = []

    for i in range(len(array1)):
        name = array1[i].text.strip() if array1[i].text else ""
        content = array2[i].text.strip() if array2[i].text else ""
        result.append(f"{name} - {content}")

    return " ### ".join(result)

def process_all_xml_files():
    current_directory = os.getcwd()
    for file_name in os.listdir(current_directory):
        if file_name.endswith('.xml'):
            file_path = os.path.join(current_directory, file_name)
            print(f"Processing {file_name}...")
            try:
                result = process_xml(file_path)
                txt_file_name = f"{os.path.splitext(file_name)[0]}.txt"
                txt_file_path = os.path.join(current_directory, txt_file_name)
                with open(txt_file_path, 'w', encoding='utf-8') as txt_file:
                    txt_file.write(result)
                print(f"Saved to {txt_file_name}")
            except Exception as e:
                print(f"Error processing {file_name}: {str(e)}")

if __name__ == "__main__":
    current_directory = os.getcwd()
    process_directory(current_directory)
    process_all_xml_files()