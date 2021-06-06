"""moduły"""
import random
from os import system, name

BOARD_SIZE = 9
board = ['0', '1', '2', '3', '4', '5', '6', '7', '8']

PLAYER_ONE = 'O'
PLAYER_TWO = 'X'

players = {
    'computer': '?',
    'player': '?'
}

winning_sets = [[0, 1, 2], [0, 3, 6], [0, 4, 8], [1, 4, 7],
                [2, 5, 8], [3, 4, 5], [6, 7, 8], [2, 4, 6]]


# def clear():
#     """czyszczenie konsoli"""
#     if name == 'nt':
#         _ = system('clear')


def print_board():
    """drukowanie tablicy"""
    # print('\n\n')
    # clear()
    print_str = ''
    for i in range(len(board)):
        if i % 3 == 0:
            print_str += '\n'
        else:
            print_str += ' | '
        print_str += board[i]
    print(print_str)
    print('\n')


def setup():
    """losowanie kto czym gra"""
    rand = random.randint(0, 1)
    if rand == 0:
        players['computer'] = PLAYER_ONE
        players['player'] = PLAYER_TWO
    else:
        players['computer'] = PLAYER_TWO
        players['player'] = PLAYER_ONE

    print(f"Gracz gra jako: {players['player']}")
    input("Kliknij dowolny przycisk aby kontynuować.")


def player_turn():
    """tura gracza"""
    print('\nPlayer turn.')
    field_nr = input('Podaj numer pola do zaznaczenia: ')
    field_nr = int(field_nr)
    if field_nr >= BOARD_SIZE or field_nr < 0:
        print(f'Numer pola musi być dodatni i mniejszy niż {BOARD_SIZE}.')
        player_turn()
        return
    if board[field_nr] == PLAYER_ONE or board[field_nr] == PLAYER_TWO:
        print(f'Pole {field_nr} jest zajęte.')
        player_turn()
        return

    board[field_nr] = players['player']


def computer_turn_hepler(winning_set, player, possibilities, best_possibilities):
    """decyzje dla komputera"""
    fields = [0, 1, 2]
    w_fields = [0, 1, 2]
    for field in fields:
        if board[winning_set[field]] == players[player]:
            w_fields.remove(field)
    if len(w_fields) == 1:
        if winning_set[w_fields[0]] in possibilities:
            board[winning_set[w_fields[0]]] = players['computer']
            return 1
    # pola z winning setów, na których jest znacznik komputera
    # a nie są zajęte przez gracza trafiają do best_possibilities
    elif len(w_fields) == 2 and player == 'computer':
        if players['player'] not in [board[winning_set[w_fields[0]]],
                                     board[winning_set[w_fields[1]]]]:
            for i in range(2):
                if winning_set[w_fields[i]] in possibilities:
                    best_possibilities.append(winning_set[w_fields[i]])
    return 0


def computer_turn():
    """tura komputera"""
    print('\nComputer turn.')
    possibilities = []
    best_possibilities = []

    # possibilities to są wszystkie możliwe ruchy
    for i in range(len(board)):
        if board[i].isdigit():
            possibilities.append(i)

    for winning_set in winning_sets:  # sprawdzamy, czy ktoś ma możliwą wygraną

        # czy komputer ma wygrana
        if computer_turn_hepler(winning_set, 'computer', possibilities, best_possibilities) == 1:
            return

        # czy gracz ma wygrana
        if computer_turn_hepler(winning_set, 'player', possibilities, best_possibilities) == 1:
            return

    if len(best_possibilities) == 0:
        board[possibilities[random.randint(0, len(possibilities) - 1)]] \
            = players['computer']
    else:
        board[best_possibilities[random.randint(0, len(best_possibilities) - 1)]] \
            = players['computer']


def check_win():
    """sprawdzanie czy gra się zakończyła"""
    for winning_set in winning_sets:
        if board[winning_set[0]] == board[winning_set[1]] == board[winning_set[2]]:
            return board[winning_set[0]]

    temp = list()
    for item in board:
        if item.isdigit():
            temp.append(item)
    if len(temp) == 0:
        return 'TIE'

    return None


def game():
    """główna pętla gry"""
    win = None
    turn = 1

    while not win:

        if players['computer'] == PLAYER_ONE:
            if turn % 2 == 1:
                computer_turn()
            else:
                player_turn()
        else:
            if turn % 2 == 1:
                player_turn()
            else:
                computer_turn()
        win = check_win()
        print_board()
        turn += 1

    if win == players['computer']:
        print('Komputer wygrał.')
    elif win == players['player']:
        print('\nGracz wygrał.')
    else:
        print('\nRemis.')


if __name__ == '__main__':
    print_board()
    setup()
    game()
    input('\nNasiśnij dowolny klawisz, żeby zakończyć program.')
