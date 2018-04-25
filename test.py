# Python application to test miniconda data science installation

import math
import os
import sys

libs = ["numpy", "pandas", "matplotlib", "sklearn", "skimage", "cv2",
        "sqlalchemy", "bokeh", "nltk", "missingno", "geopandas", "wordcloud",
        "lightgbm", "scipy", "xgboost", "catboost", "keras"]

def main():
    print("Please wait, testing Python environment....")
    test_is_python_35()
    test_libs()
    test_tensorflow()
    test_keras()

def test_libs():
    for x in libs:
        try:
            __import__(x)
        except ImportError:
            print("Testing {:s} -> FAIL".format(x))
            continue
        print("Testing {:s} -> OK".format(x))

def test_keras():
    try:
        import keras
    except ImportError:
        print("Testing keras -> FAIL")
        return
    print("Testing keras -> OK")

def test_tensorflow():
    try:
        import tensorflow
    except ImportError:
        print("Testing tensorflow -> FAIL")
        return
    print("Testing tensorflow -> OK")

def test_is_python_35():
    major = sys.version_info.major
    minor = sys.version_info.minor
    if major == 3:
        pass 
    else:
        print("You are running Python {}, but we need Python {}.".format(major, 3))
        print("Stopping here.")

        #Stop here
        sys.exit(1)
        return None
        # assert major == 3, "Stopping here - we need Python 3."

    if minor >= 5:
        print("Testing Python version-> py{}.{} OK".format(major, minor))
    else:
        print("Warning: You should be running Python 3.5 or newer, " +
              "you have Python {}.{}.".format(major, minor))

main()
