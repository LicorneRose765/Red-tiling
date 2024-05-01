import numpy as np
import matplotlib.pyplot as plt
from matplotlib.colors import ListedColormap


pieces_dict = {
    1: [(0,0)],
    2: [(0,0), (0,1)],
    3: [(0,0), (0,1), (0,2)],
    4: [(0,0), (0,1), (1,0)],
    5: [(0,0), (0,1), (1,1), (1,0)],
    6: [(0,0), (1,0), (1,1), (2,1)],
    7: [(0,1), (1,1), (1,0), (2,0)],
    8: [(0,2), (0,1), (0,0), (1,0)],
    9: [(0,0), (1,0), (1,1), (1,3)],
    10: [(0,1), (1,1), (1,0), (2,1)],
    11: [(0,0), (0,1), (0, 2), (0,3)]
}


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
        color = 2
    elif color.strip() == "blue":
        color = 1
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
        pieces = []

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
                if len(pieces) != 0:
                    print("Error: multiple h lines found in the db file")
                    exit(1)
                # Contains the input set Q.
                tmp = line.split("(")[1].split(",")
                if len(tmp) != 11:
                    print(f"Error: {len(tmp)} type found but 11 are expected")
                    exit(1)
                for i in range(len(tmp)):
                    number = 0
                    if i == len(tmp) - 1:
                        number = int(tmp[i].split(")")[0])
                    else:
                        number = int(tmp[i])
                    if number != 0:
                        pieces.append((i+1, number))

        return board, pieces


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
    colors = ['white', 'blue', 'red']  # Add more colors as needed

    # Create a custom colormap
    cmap_custom = ListedColormap(colors)

    fig, ax = plt.subplots()
    extent = [0, np_array.shape[1], 0, np_array.shape[0]]
    ax.imshow(np_array, cmap=cmap_custom, interpolation="nearest", extent=extent)

    # Force integer ticks
    ax.set_xticks(np.arange(0, np_array.shape[1], 1))
    ax.set_yticks(np.arange(0, np_array.shape[0], 1))

    plt.grid(True)
    plt.title(name.split(".")[0].split("/")[-1])
    plt.show()


def get_board_for_piece(piece_type):
    """
    Get the board for a given piece type (used to display it)
    """
    board = np.zeros((3, 4), dtype=int)

    # Add points to the piece
    for point in pieces_dict[piece_type]:
        board[point[0]][point[1]] = 1

    return board


def display_pieces(pieces):
    """
    Display the pieces in a window

    - pieces: a list of tuples (piece_type, number_of_pieces)
    """

    # Define custom colormap
    colors = ['white', 'red']  # Add more colors as needed

    # Create a custom colormap
    cmap_custom = ListedColormap(colors)

    boards = []
    for piece, _ in pieces:
        board = get_board_for_piece(piece)
        boards.append(board)

    # === Display the pieces ===
    num_pieces = len(pieces)
    rows = (num_pieces + 2) // 3
    fig, axes = plt.subplots(rows, 3, figsize=(10, 10))

    # Iterate over the pieces
    for i, board in enumerate(boards):
        if i >= num_pieces:
            axes.flat[i].axis("off") # hide unused subplots
            continue

        # Display the board
        extent = [0, board.shape[1], 0, board.shape[0]]
        axes.flat[i].imshow(board, cmap=cmap_custom, interpolation="nearest", extent=extent)
        axes.flat[i].grid(True)

        # Force integer ticks
        axes.flat[i].set_xticks(np.arange(0, board.shape[1], 1))
        axes.flat[i].set_yticks(np.arange(0, board.shape[0], 1))

        number = pieces[i][1]
        text = ""
        if number > 1:
            text = f"Piece {pieces[i][0]} ({number} are available)"
        else:
            text = f"Piece {pieces[i][0]} ({number} is available)"
        axes.flat[i].set_title(text)

    # Hide unused subplots
    for i in range(num_pieces, rows * 3):
        axes.flat[i].axis("off")

    plt.tight_layout()
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
    
    board, pieces = read_db_file(db_file)
    print_board(board)
    display_board(board, db_file)
    display_pieces(pieces)
