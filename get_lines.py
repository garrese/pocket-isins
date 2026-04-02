import sys

def main():
    with open('lib/features/portfolio/presentation/portfolio_screen.dart', 'r') as f:
        lines = f.readlines()
        for i, line in enumerate(lines[120:190]):
            print(f"{i+121}: {line}", end='')

if __name__ == "__main__":
    main()
