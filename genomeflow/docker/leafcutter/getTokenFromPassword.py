#!/miniconda/bin/python

from IPython.lib import passwd
import sys, getopt

def main(argv):
    inputPassword = ''
    try:
        opts, args = getopt.getopt(argv,"hp:",["password="])
    except getopt.GetoptError:
        print("getTokenFromPassword -p <password>")
        sys.exit(2)
    for opt, arg in opts:
        if opt == '-h':
            print("getTokenFromPassword -p <password>")
            sys.exit()
        elif opt in ("-p","--password"):
            inputPassword = arg
            #print("Input password is",inputPassword)
            print(passwd(arg))


if __name__ == "__main__":
    main(sys.argv[1:])
