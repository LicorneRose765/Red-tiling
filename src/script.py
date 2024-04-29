import numpy as np
import matplotlib.pyplot as plt
from matplotlib.colors import ListedColormap


def read_tile(string):
    """
    Read a tile from a string.
    
    # Returns : 
    - color: the color of the tile (0 for white, 1 for red, 2 for blue)
    - x: the x coordinate of the tile
    - y: the y coordinate of the tile
    """
    split = string.split("(")
    color = split[0]
    if color.strip() == "red":
        color = 1
    elif color.strip() == "blue":
        color = 2
    else:
        # default value
        color = 0
    x = int(split[1].split(",")[0])
    y = int(split[1].split(",")[1].split(")")[0])
    return color, x, y


def read_db_file(db_file):
    """
    Read the content of a db and return a numpy array representing the board.
    board[i][j] = 0 if it's a white cell
    board[i][j] = 1 if it's a red cell
    board[i][j] = 2 if it's a blue cell

    # Returns:
    - board: a numpy array representing the board
    """
    with open(db_file, "r") as f:
        lines = f.readlines()
        tmp = lines[0].split(",")
        n = int(tmp[0].split("(")[1])
        m = int(tmp[1].split(",")[0])
        print(f"n = {n}, m = {m}")

        board = np.zeros((m, n), dtype=int)

        for line in lines[1:]:
            if line.startswith(("red", "blue")):
                vals = line.split(".")
                for val in vals:
                    if val != "\n":
                        # iterate over all the tiles defined in the line
                        color, x, y = read_tile(val)
                        board[m-y-1][x] = color
                        # print(f"color = {color}, x = {x}, y = {y}")
            if line.startswith("h"):
                # Contains the input set Q.
                continue

        return board    


def print_board(np_array):
    """
    print the board in the terminal
    """
    for i in range(np_array.shape[0]-1, -1, -1):
        for j in range(np_array.shape[1]):
            if np_array[i][j] == 0:
                print("W", end=" ")
            elif np_array[i][j] == 1:
                print("R", end=" ")
            elif np_array[i][j] == 2:
                print("B", end=" ")
        print()


def display_board(np_array, name="Board"):
    """
    Display the board in a window
    """

    # Define custom colormap
    colors = ['white', 'red', 'blue']  # Add more colors as needed

    # Create a custom colormap
    cmap_custom = ListedColormap(colors)

    fig, ax = plt.subplots()
    extent = [0, np_array.shape[1], 0, np_array.shape[0]]
    ax.imshow(np_array, cmap=cmap_custom, interpolation="nearest", extent=extent)

    plt.grid(True)
    plt.title(name.split(".")[0].split("/")[-1])
    plt.show()


if __name__ == "__main__":
    import sys

    if len(sys.argv) < 2 or len(sys.argv) > 3:
        print("Usage: python script.py <db file> [<solution>]")
        sys.exit(1)
    
    db_file = sys.argv[1]
    solution = None
    if len(sys.argv) == 3:
        solution = sys.argv[2]
    
    board = read_db_file(db_file)
    print_board(board)
    display_board(board, db_file)
