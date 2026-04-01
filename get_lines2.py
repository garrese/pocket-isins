import sys

def main():
    with open('lib/features/portfolio/presentation/screens/markets_step_screen.dart', 'r') as f:
        lines = f.readlines()
        for i, line in enumerate(lines):
            if "market" in line.lower():
                print(f"{i+1}: {line}", end='')

if __name__ == "__main__":
    main()
