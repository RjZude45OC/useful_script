from colorama import init, Fore, Style
from datetime import datetime
import sys

# Initialize colorama for Windows compatibility
init()

def compare_files(file1_path, file2_path):
    # Print header with current UTC time
    current_time = datetime.utcnow().strftime('%Y-%m-%d %H:%M:%S')
    print(f"\n{Fore.CYAN}File Comparison Report{Style.RESET_ALL}")
    print(f"{Fore.CYAN}Date and Time (UTC): {current_time}{Style.RESET_ALL}")
    print(f"{Fore.CYAN}Performed by: {sys.argv[0]}{Style.RESET_ALL}")
    
    try:
        # Read both files with line numbers
        with open(file1_path, 'r') as f1:
            lines1 = {line.rstrip(): idx + 1 for idx, line in enumerate(f1)}
        with open(file2_path, 'r') as f2:
            lines2 = {line.rstrip(): idx + 1 for idx, line in enumerate(f2)}
        
        # Find missing lines in each file
        missing_in_file2 = set(lines1.keys()) - set(lines2.keys())
        missing_in_file1 = set(lines2.keys()) - set(lines1.keys())
        
        # Print results for lines missing in file 2
        print(f"\n{Fore.GREEN}Lines missing in {file2_path}:{Style.RESET_ALL}")
        print(f"{Fore.YELLOW}{'=' * 60}{Style.RESET_ALL}")
        if missing_in_file2:
            for line in sorted(missing_in_file2, key=lambda x: lines1[x]):
                print(f"{Fore.CYAN}Line {lines1[line]:4d}{Style.RESET_ALL} | {Fore.WHITE}{line}{Style.RESET_ALL}")
        else:
            print(f"{Fore.WHITE}No missing lines{Style.RESET_ALL}")
        
        # Print results for lines missing in file 1
        print(f"\n{Fore.GREEN}Lines missing in {file1_path}:{Style.RESET_ALL}")
        print(f"{Fore.YELLOW}{'=' * 60}{Style.RESET_ALL}")
        if missing_in_file1:
            for line in sorted(missing_in_file1, key=lambda x: lines2[x]):
                print(f"{Fore.CYAN}Line {lines2[line]:4d}{Style.RESET_ALL} | {Fore.WHITE}{line}{Style.RESET_ALL}")
        else:
            print(f"{Fore.WHITE}No missing lines{Style.RESET_ALL}")
            
        # Print summary
        print(f"\n{Fore.YELLOW}Summary:{Style.RESET_ALL}")
        print(f"Total lines missing in {file2_path}: {len(missing_in_file2)}")
        print(f"Total lines missing in {file1_path}: {len(missing_in_file1)}")
            
    except FileNotFoundError as e:
        print(f"{Fore.RED}Error: {e}")
        print("Please make sure both files exist and are accessible.{Style.RESET_ALL}")
    except Exception as e:
        print(f"{Fore.RED}An error occurred: {e}{Style.RESET_ALL}")

if __name__ == "__main__":
    if len(sys.argv) != 3:
        print(f"{Fore.RED}Usage: python compare_files.py <file1> <file2>{Style.RESET_ALL}")
        sys.exit(1)
    
    file1_path = sys.argv[1]
    file2_path = sys.argv[2]
    compare_files(file1_path, file2_path)