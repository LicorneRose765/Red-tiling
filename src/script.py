import numpy as np
import matplotlib.pyplot as plt
from matplotlib.colors import ListedColormap
from more_itertools import first_true
import subprocess
import time


pieces_dict = {
    1: [(0,0)],
    2: [(0,0), (0,1)],
    3: [(0,0), (0,1), (0,2)],
    4: [(0,0), (0,1), (1,0)],
    5: [(0,0), (0,1), (1,1), (1,0)],
    6: [(0,0), (1,0), (1,1), (2,1)],
    7: [(0,1), (1,1), (1,0), (2,0)],
    8: [(0,2), (0,1), (0,0), (1,0)],
    9: [(1,0), (2,0), (2,1), (2,2)],
    10: [(0,1), (1,1), (1,0), (2,1)],
    11: [(0,0), (1,0), (2, 0), (3,0)]
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
    - pieces: a list of tuples (piece_type, number_of_pieces)
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
    for i in range(np_array.shape[0]):
        for j in range(np_array.shape[1]):
            if np_array[i][j] == 0:
                print("W", end=" ")
            elif np_array[i][j] == 2:
                print("R", end=" ")
            elif np_array[i][j] == 1:
                print("B", end=" ")
            else:
                print(np_array[i][j] - 2, end=" ")
        print()


def get_board_for_piece(piece_type):
    """
    Get the board for a given piece type (used to display it)
    """
    board = np.zeros((3, 4), dtype=int)

    # Add points to the piece
    for point in pieces_dict[piece_type]:
        board[point[1]][point[0]] = 1

    return board[::-1]


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


def read_sol(solution):
    """
    Read a solution string and return a tuple (piece_type, x, y)
    
    - Input : example "one_sol(T, X, Y)" or "two_sol(T, R, X, Y)".

    - Returns : (piece_type, tiles) where tiles is a list of tuples (x, y)
    """
    piece_type = None
    tiles = []
    split = solution.split(",")
    
    if len(split) == 3:
        # One
        piece_type = 1
        x = int(split[1].strip())
        y = int(split[2].strip()[:-1])
        tiles.append((x, y))
    elif len(split) >= 6 or len(split) <= 10:
        # Two
        piece_type = int(split[0].split("(")[1].strip())
        for i in range(2, len(split), 2):
            if i == len(split) - 2:
                x = int(split[i].strip())
                y = int(split[i+1].strip()[:-1])
                tiles.append((x, y))
            else:
                x = int(split[i].strip())
                y = int(split[i+1].strip())
                tiles.append((x, y))
    
    
    return (piece_type, tiles)


def add_solutions_to_board(board_old, solution_list):
    """
    Read a solution string and update the board accordingly
    """
    # Copy the board
    board = board_old.copy()
    m = len(board) # Number of rows

    for solution in solution_list:
        if solution.startswith("one_sol") or solution.startswith("two_sol") or solution.startswith("three_sol") or solution.startswith("four_sol"):
            piece_type, tiles = read_sol(solution)
            for tile in tiles:
                x, y = tile
                board[m - y - 1][x] = piece_type + 2  # Add 2 to differentiate the pieces from the board

    return board       


def display_board(board, name="Board"):
    # Create a custom colormap
    color_map = {
        0: np.array([255,255,255]), # white
        1: np.array([0,0,255]), # blue
        2: np.array([255,0,0]), # red
        # random color for each piece
        3: np.array([255,255,0]), # yellow type 1
        4: np.array([0,255,0]), # green type 2
        5: np.array([255,0,255]), # pink type 3 
        6: np.array([0,255,255]), # cyan type 4
        7: np.array([255,128,0]), # orange type 5
        8: np.array([128,0,255]), # purple type 6
        9: np.array([0,128,255]), # light blue type 7
        10: np.array([128,255,0]), # light green type 8
        11: np.array([255,0,128]), # dark pink type 9 
        12: np.array([0,255,128]), # dark cyan type 10
        13: np.array([128,255,255]), # light cyan type 11
    }

    # make a 3d numpy array that has a color channel dimension
    data_3d = np.ndarray(shape=(board.shape[0], board.shape[1], 3), dtype=int)
    for i in range(0, board.shape[0]):
        for j in range(0, board.shape[1]):
            data_3d[i][j] = color_map[board[i][j]]

    # display the plot
    fig, ax = plt.subplots(1, 1)
    extent = [0, board.shape[1], 0, board.shape[0]]
    ax.imshow(data_3d, interpolation="nearest", extent=extent)

    n = board.shape[1]
    m = board.shape[0]
    for i in range(0, board.shape[0]):
        for j in range(0, board.shape[1]):
            c = board[i][j]
            if c > 2:
                ax.text(j, m-i-1, str(c-2), color='black', fontsize=12, fontweight='bold')

    # Force integer ticks
    ax.set_xticks(np.arange(0, board.shape[1], 1))
    ax.set_yticks(np.arange(0, board.shape[0], 1))

    plt.grid(True)
    plt.title(name.split(".")[0].split("/")[-1])
    plt.show()


def read_generated_board(generated, pieces_to_add=0):
    """
    Read the output of a generator, return the board and a string containing an output corresponding to solver standards  


    # Input:
    - List of string containing the output of a generator. This list contains a list of predicate :
        - `blue(X,Y)` for the position of blue cells
        - `red(X,Y)` for the position of red cells
        - `params(N,M,K)` for the size of the grid (N X M) and the maximum number of blue cells that can be covered
        - `[one/two/three/four]_sol(T, X, Y)` a piece of type T is in the set and used in the solution

    # Outputs:
    - The corresponding board. (without pieces)
    - The list of pieces available. (A list of tuples (piece_type, number_of_pieces))
    - A string containing the corrsponding solver input for the generated instance.
    """

    board = None
    # Find params
    params = first_true(generated, None, pred=lambda x: x.startswith("params"))
    if params is None:
        print("Error: params not found in the generated output")
        exit(1)
    n, m, k = params.split("(")[1].split(")")[0].split(",")
    n = int(n)
    m = int(m)
    k = int(k)
    board = np.zeros((m, n), dtype=int)


    color_tile = []
    tiles_dict = {}

    # Iterate over the generated output
    for pred in generated:
        if pred.startswith("blue") or pred.startswith("red"):
            # Read blue
            color, x, y = read_tile(pred)
            if x >= 0 and y >= 0 and x < n and y < m:
                color_tile.append((color, x, y))
                board[m-y-1][x] = color

        elif pred.startswith(("one_sol", "two_sol", "three_sol", "four_sol")):
            piece_type, tiles = read_sol(pred)
            if piece_type not in tiles_dict:
                tiles_dict[piece_type] = 1
            else:
                tiles_dict[piece_type] += 1

    output_string = f"params({n},{m},{k}).\n"
    # Red and blue cells
    for color, x, y in color_tile:
        if color == 2:
            output_string += f"red({x},{y}).\n"
        elif color == 1:
            output_string += f"blue({x},{y}).\n"

    if pieces_to_add > 0:
        # Add random pieces to the instance
        tiles_dict = add_random_pieces(tiles_dict, pieces_to_add)
    
    output_string += "h("
    for i in range(1,12):
        if i in tiles_dict:
            output_string += f"{tiles_dict[i]},"
        else:
            output_string += "0,"
    output_string = output_string[:-1] + ").\n"

    pieces = [(piece_type, tiles_dict[piece_type]) for piece_type in tiles_dict]
    return board, pieces, output_string


def add_random_pieces(pieces, number=1):
    """
    Add random pieces to the list of pieces

    - pieces: a list of tuples (piece_type, number_of_pieces)
    - number: the number of pieces to add
    """
    if number == 0:
        return pieces
    for _ in range(number):
        piece_type = np.random.randint(1, 12)
        if piece_type not in pieces:
            pieces[piece_type] = 1
        else:
            pieces[piece_type] += 1
    return pieces


def generate_instance(params, output_folder="resources/timeAnalysis/", square=True):
    print("===================== GENERATE INSTANCE =====================")
    if square:
        size, red, blue, pieces, toAdd = params
        size_x, size_y = size, size
    else:
        size_x, size_y, red, blue, pieces, toAdd = params

    print(
        f"Size: {size_x}x{size_y}, Red: {red}, Blue: {blue}, Pieces: {pieces}, Pieces to add: {toAdd}."
    )

    k = 0

    # Modify genInput.db file according to the parameters
    new_input = f"params({size_x},{size_y},{k}).\n"
    new_red = f"redNumber({red}).\n"
    new_blue = f"blueNumber({blue}).\n"
    new_pieces = f"pieces({pieces}).\n"
    with open("resources/autoGenInput.db", "w") as f:
        f.write(new_input)
        f.write(new_red)
        f.write(new_blue)
        f.write(new_pieces)

    seed = int(time.time() + np.random.randint(0, 1000))

    file_name = f"{size_x}x{size_y}.{red}.{blue}.db"

    command = f"clingo -n 1 --rand-freq=1 --seed={seed} solvers/param_generator.lp resources/autoGenInput.db  --verbose=0"

    output = subprocess.run(command.split(), capture_output=True, text=True)

    output = output.stdout

    if "UNSATISFIABLE" in output:
        print("No solution found.")
    else:
        # Print the solution
        predicates = output.split("\n")[0].split(" ")

        board, pieces, solver_input = read_generated_board(predicates, toAdd)

        # Save solver input in a file
        with open(f"{output_folder}{file_name}", "w") as f:
            f.write(solver_input)

        display_board(board, file_name)


if __name__ == "__main__":
    p = 0.42
    while True:
        x = int(input("x size= "))
        y = int(input("y size= "))
        print(f"red number = {int(p*x*y)}")