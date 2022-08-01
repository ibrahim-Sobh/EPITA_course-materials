import sys
import P2DC_Team_13 as process


if __name__ == "__main__":
      inputArgs = sys.argv
      Global=0
      try:
           for i in range(1, len(inputArgs)):
                fname=sys.argv[i]
                file=open(fname,'r')
                Global+=process.process_file(file)
                file.close()
           print("Globale Score:",str(Global))
      except FileNotFoundError:
          print("Wrong file or file path")