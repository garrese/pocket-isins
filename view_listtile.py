import sys

def main():
    with open('lib/features/portfolio/presentation/portfolio_screen.dart', 'r') as f:
        lines = f.readlines()
        for i, line in enumerate(lines[128:193]):
            print(f"{i+129}: {line}", end='')

if __name__ == "__main__":
    main()
