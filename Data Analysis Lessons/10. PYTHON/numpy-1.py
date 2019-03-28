{
 "cells": [
  {
   "cell_type": "markdown",
   "metadata": {},
   "source": [
    "# Python lesson plans"
   ]
  },
  {
   "cell_type": "markdown",
   "metadata": {},
   "source": [
    "Variable assignment conventions: \n",
    "- Not permitted: variables cannot start with numbers, can't use operators, spaces, slash, ., ?, !, $, #\n",
    "- Permitted: letters, digits only after letters, underscores"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 17,
   "metadata": {},
   "outputs": [],
   "source": [
    "var = 2 # variables sart with lower letter"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 18,
   "metadata": {},
   "outputs": [
    {
     "data": {
      "text/plain": [
       "2"
      ]
     },
     "execution_count": 18,
     "metadata": {},
     "output_type": "execute_result"
    }
   ],
   "source": [
    "var"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 19,
   "metadata": {},
   "outputs": [],
   "source": [
    "Array1 = [1,2,3] #array list"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 20,
   "metadata": {},
   "outputs": [
    {
     "data": {
      "text/plain": [
       "[1, 2, 3]"
      ]
     },
     "execution_count": 20,
     "metadata": {},
     "output_type": "execute_result"
    }
   ],
   "source": [
    "Array1"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 21,
   "metadata": {},
   "outputs": [
    {
     "data": {
      "text/plain": [
       "[1, 2, 3, 1, 2, 3]"
      ]
     },
     "execution_count": 21,
     "metadata": {},
     "output_type": "execute_result"
    }
   ],
   "source": [
    "2*Array1"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 27,
   "metadata": {},
   "outputs": [],
   "source": [
    "Array2 = ([1,2],[3,4])"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 28,
   "metadata": {},
   "outputs": [
    {
     "data": {
      "text/plain": [
       "([1, 2], [3, 4])"
      ]
     },
     "execution_count": 28,
     "metadata": {},
     "output_type": "execute_result"
    }
   ],
   "source": [
    "Array2"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 29,
   "metadata": {},
   "outputs": [
    {
     "data": {
      "text/plain": [
       "([1, 2], [3, 4], [1, 2], [3, 4])"
      ]
     },
     "execution_count": 29,
     "metadata": {},
     "output_type": "execute_result"
    }
   ],
   "source": [
    "Array2 + Array2"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 23,
   "metadata": {},
   "outputs": [],
   "source": [
    "A_B = 1"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 24,
   "metadata": {},
   "outputs": [
    {
     "data": {
      "text/plain": [
       "1"
      ]
     },
     "execution_count": 24,
     "metadata": {},
     "output_type": "execute_result"
    }
   ],
   "source": [
    "A_B"
   ]
  },
  {
   "cell_type": "raw",
   "metadata": {},
   "source": [
    "family_member_names = [] #kebab case"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 26,
   "metadata": {},
   "outputs": [
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "[]\n"
     ]
    }
   ],
   "source": [
    "print (family_member_names)"
   ]
  },
  {
   "cell_type": "markdown",
   "metadata": {},
   "source": [
    "Conditional statement conventions: \n",
    "- If else do not go into parentheses, curly brackets or square brackets are not used\n",
    "- Note spaces and indentations "
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 27,
   "metadata": {},
   "outputs": [
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "var is not 1\n"
     ]
    }
   ],
   "source": [
    "if var == 1: \n",
    "    print(\"var is 1\")\n",
    "else : \n",
    "    print(\"var is not 1\")\n",
    "    "
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 30,
   "metadata": {},
   "outputs": [
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "1\n",
      "2\n",
      "3\n",
      "1, 2, 3\n"
     ]
    }
   ],
   "source": [
    "print (\"1\")\n",
    "print (\"2\")\n",
    "print (\"3\")\n",
    "print (\"1, 2, 3\")"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 29,
   "metadata": {},
   "outputs": [
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "1, 2, 3\n"
     ]
    }
   ],
   "source": [
    "print (\"1, 2, 3\")"
   ]
  },
  {
   "cell_type": "markdown",
   "metadata": {},
   "source": [
    "For loop conventions:  \n",
    "- for is a keyword among a few others in python\n",
    "- explore arrays using 'for' loops or 'while'"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 31,
   "metadata": {},
   "outputs": [
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "1\n",
      "2\n",
      "3\n"
     ]
    }
   ],
   "source": [
    "for i in Array1:\n",
    "    print(i)\n",
    "    "
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 1,
   "metadata": {
    "scrolled": true
   },
   "outputs": [
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "15\n",
      "14\n",
      "13\n",
      "12\n",
      "11\n"
     ]
    }
   ],
   "source": [
    "i = 15\n",
    "while i>10:\n",
    "    print(i)\n",
    "    i = i-1\n",
    "    "
   ]
  },
  {
   "cell_type": "markdown",
   "metadata": {},
   "source": [
    "# This is a lesson plan for numpy "
   ]
  },
  {
   "cell_type": "markdown",
   "metadata": {},
   "source": [
    "Intro to numpy features:\n",
    "- arrays, vectors, and matrices\n",
    "- matrix multiplications\n",
    "- eigen values and eigen vectors\n",
    "- solving linear systems"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 3,
   "metadata": {},
   "outputs": [],
   "source": [
    "import numpy as np"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 4,
   "metadata": {},
   "outputs": [],
   "source": [
    "Array = np.array([1,2,3])"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 5,
   "metadata": {},
   "outputs": [
    {
     "data": {
      "text/plain": [
       "array([1, 2, 3])"
      ]
     },
     "execution_count": 5,
     "metadata": {},
     "output_type": "execute_result"
    }
   ],
   "source": [
    "Array"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 6,
   "metadata": {},
   "outputs": [
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "1\n",
      "2\n",
      "3\n"
     ]
    }
   ],
   "source": [
    "for e in Array:\n",
    "    print (e)"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 11,
   "metadata": {},
   "outputs": [
    {
     "data": {
      "text/plain": [
       "array([2, 4, 6])"
      ]
     },
     "execution_count": 11,
     "metadata": {},
     "output_type": "execute_result"
    }
   ],
   "source": [
    "Array + Array"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 12,
   "metadata": {},
   "outputs": [
    {
     "data": {
      "text/plain": [
       "array([2, 4, 6])"
      ]
     },
     "execution_count": 12,
     "metadata": {},
     "output_type": "execute_result"
    }
   ],
   "source": [
    "2* Array"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 40,
   "metadata": {},
   "outputs": [
    {
     "data": {
      "text/plain": [
       "array([1.        , 1.41421356, 1.73205081])"
      ]
     },
     "execution_count": 40,
     "metadata": {},
     "output_type": "execute_result"
    }
   ],
   "source": [
    "np.sqrt(Array) #square root of array2"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 41,
   "metadata": {},
   "outputs": [
    {
     "data": {
      "text/plain": [
       "array([0.        , 0.69314718, 1.09861229])"
      ]
     },
     "execution_count": 41,
     "metadata": {},
     "output_type": "execute_result"
    }
   ],
   "source": [
    "np.log(Array) #log of array2"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 42,
   "metadata": {},
   "outputs": [
    {
     "data": {
      "text/plain": [
       "array([ 2.71828183,  7.3890561 , 20.08553692])"
      ]
     },
     "execution_count": 42,
     "metadata": {},
     "output_type": "execute_result"
    }
   ],
   "source": [
    "np.exp(Array) #exponential of array2"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 43,
   "metadata": {},
   "outputs": [
    {
     "data": {
      "text/plain": [
       "6"
      ]
     },
     "execution_count": 43,
     "metadata": {},
     "output_type": "execute_result"
    }
   ],
   "source": [
    "np.sum(Array)"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 44,
   "metadata": {},
   "outputs": [
    {
     "data": {
      "text/plain": [
       "3.7416573867739413"
      ]
     },
     "execution_count": 44,
     "metadata": {},
     "output_type": "execute_result"
    }
   ],
   "source": [
    "np.linalg.norm(Array)"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 46,
   "metadata": {},
   "outputs": [],
   "source": [
    "M = np.matrix([[1,5], [6,8]])"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 47,
   "metadata": {},
   "outputs": [
    {
     "data": {
      "text/plain": [
       "matrix([[1, 5],\n",
       "        [6, 8]])"
      ]
     },
     "execution_count": 47,
     "metadata": {},
     "output_type": "execute_result"
    }
   ],
   "source": [
    "M"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 49,
   "metadata": {},
   "outputs": [],
   "source": [
    "A = np.array(M)"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 50,
   "metadata": {},
   "outputs": [
    {
     "data": {
      "text/plain": [
       "array([[1, 5],\n",
       "       [6, 8]])"
      ]
     },
     "execution_count": 50,
     "metadata": {},
     "output_type": "execute_result"
    }
   ],
   "source": [
    "A"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 51,
   "metadata": {},
   "outputs": [
    {
     "data": {
      "text/plain": [
       "array([[1, 6],\n",
       "       [5, 8]])"
      ]
     },
     "execution_count": 51,
     "metadata": {},
     "output_type": "execute_result"
    }
   ],
   "source": [
    "A.T #use T for transpose"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 52,
   "metadata": {},
   "outputs": [],
   "source": [
    "Z = np.zeros(11) #generate an array"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 54,
   "metadata": {},
   "outputs": [
    {
     "data": {
      "text/plain": [
       "array([0., 0., 0., 0., 0., 0., 0., 0., 0., 0., 0.])"
      ]
     },
     "execution_count": 54,
     "metadata": {},
     "output_type": "execute_result"
    }
   ],
   "source": [
    "Z"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 57,
   "metadata": {},
   "outputs": [],
   "source": [
    "Z = np.zeros((11,11)) #generate a marix of zeros"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 60,
   "metadata": {},
   "outputs": [
    {
     "data": {
      "text/plain": [
       "array([[0., 0., 0., 0., 0., 0., 0., 0., 0., 0., 0.],\n",
       "       [0., 0., 0., 0., 0., 0., 0., 0., 0., 0., 0.],\n",
       "       [0., 0., 0., 0., 0., 0., 0., 0., 0., 0., 0.],\n",
       "       [0., 0., 0., 0., 0., 0., 0., 0., 0., 0., 0.],\n",
       "       [0., 0., 0., 0., 0., 0., 0., 0., 0., 0., 0.],\n",
       "       [0., 0., 0., 0., 0., 0., 0., 0., 0., 0., 0.],\n",
       "       [0., 0., 0., 0., 0., 0., 0., 0., 0., 0., 0.],\n",
       "       [0., 0., 0., 0., 0., 0., 0., 0., 0., 0., 0.],\n",
       "       [0., 0., 0., 0., 0., 0., 0., 0., 0., 0., 0.],\n",
       "       [0., 0., 0., 0., 0., 0., 0., 0., 0., 0., 0.],\n",
       "       [0., 0., 0., 0., 0., 0., 0., 0., 0., 0., 0.]])"
      ]
     },
     "execution_count": 60,
     "metadata": {},
     "output_type": "execute_result"
    }
   ],
   "source": [
    "Z"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 58,
   "metadata": {},
   "outputs": [],
   "source": [
    "X = np.ones((10,10)) #generate a marix of ones"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 59,
   "metadata": {},
   "outputs": [
    {
     "data": {
      "text/plain": [
       "array([[1., 1., 1., 1., 1., 1., 1., 1., 1., 1.],\n",
       "       [1., 1., 1., 1., 1., 1., 1., 1., 1., 1.],\n",
       "       [1., 1., 1., 1., 1., 1., 1., 1., 1., 1.],\n",
       "       [1., 1., 1., 1., 1., 1., 1., 1., 1., 1.],\n",
       "       [1., 1., 1., 1., 1., 1., 1., 1., 1., 1.],\n",
       "       [1., 1., 1., 1., 1., 1., 1., 1., 1., 1.],\n",
       "       [1., 1., 1., 1., 1., 1., 1., 1., 1., 1.],\n",
       "       [1., 1., 1., 1., 1., 1., 1., 1., 1., 1.],\n",
       "       [1., 1., 1., 1., 1., 1., 1., 1., 1., 1.],\n",
       "       [1., 1., 1., 1., 1., 1., 1., 1., 1., 1.]])"
      ]
     },
     "execution_count": 59,
     "metadata": {},
     "output_type": "execute_result"
    }
   ],
   "source": [
    "X"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 62,
   "metadata": {},
   "outputs": [],
   "source": [
    "Y = np.random.random((10,10))"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 63,
   "metadata": {},
   "outputs": [
    {
     "data": {
      "text/plain": [
       "array([[0.89702057, 0.33749373, 0.43660852, 0.58371346, 0.12566894,\n",
       "        0.0759833 , 0.40319589, 0.91448426, 0.46768372, 0.33136659],\n",
       "       [0.13498534, 0.07154553, 0.24129796, 0.86695928, 0.92661693,\n",
       "        0.50240303, 0.8287782 , 0.92734883, 0.12648975, 0.59783965],\n",
       "       [0.75105766, 0.70568342, 0.6141354 , 0.33219932, 0.63386293,\n",
       "        0.16603077, 0.84752173, 0.39169817, 0.03274292, 0.6049101 ],\n",
       "       [0.44693065, 0.0893177 , 0.99490356, 0.98032035, 0.30059847,\n",
       "        0.57519129, 0.55752027, 0.46939124, 0.74428386, 0.24310937],\n",
       "       [0.52626051, 0.8252973 , 0.85212406, 0.95830742, 0.15074209,\n",
       "        0.13832086, 0.5590774 , 0.0736914 , 0.62256366, 0.46811004],\n",
       "       [0.45932066, 0.38752108, 0.82329537, 0.99051027, 0.22127958,\n",
       "        0.00584663, 0.56003987, 0.69588521, 0.64060942, 0.04458117],\n",
       "       [0.79195199, 0.43187253, 0.10433456, 0.89150467, 0.09927743,\n",
       "        0.67082587, 0.29108594, 0.26725472, 0.66448038, 0.84466704],\n",
       "       [0.18758721, 0.89684686, 0.38420433, 0.14206785, 0.96832264,\n",
       "        0.63571333, 0.92815191, 0.51068652, 0.24910401, 0.34238543],\n",
       "       [0.75577784, 0.53822192, 0.79290512, 0.01335182, 0.45905928,\n",
       "        0.20356839, 0.39232058, 0.26768868, 0.7936859 , 0.9513001 ],\n",
       "       [0.58834635, 0.94174342, 0.00187049, 0.12060801, 0.83014009,\n",
       "        0.86199853, 0.4803477 , 0.86246835, 0.05373433, 0.67618292]])"
      ]
     },
     "execution_count": 63,
     "metadata": {},
     "output_type": "execute_result"
    }
   ],
   "source": [
    "Y"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 64,
   "metadata": {},
   "outputs": [],
   "source": [
    "G = np.random.randn(10,10)"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 65,
   "metadata": {},
   "outputs": [
    {
     "data": {
      "text/plain": [
       "array([[ 1.5897517 ,  0.8633084 , -1.79665642,  1.16671737,  0.07194334,\n",
       "         0.43188962, -0.98620301,  1.27884112, -0.92762259,  0.37773877],\n",
       "       [-0.06233952, -0.32940263, -2.04994122,  1.68176745, -0.12453789,\n",
       "        -0.0540392 , -1.09421155,  0.77886159, -0.03192295,  0.68051055],\n",
       "       [ 0.10438715, -0.08292667, -0.43442778, -0.45629442,  0.71049131,\n",
       "         0.89990474, -0.17691592, -1.10709951, -0.24524433, -0.86919082],\n",
       "       [ 1.6454432 ,  0.2874981 , -0.17281454, -0.59376159,  0.11402022,\n",
       "         1.17905734,  1.1970568 ,  2.19555352, -0.13050429, -0.90134185],\n",
       "       [ 2.39215444,  1.00703572,  0.24204322,  0.67289636,  0.7303574 ,\n",
       "        -1.39224299,  0.42217033,  1.04965166, -0.65226472,  0.89518914],\n",
       "       [-0.26297804,  0.99075588, -0.88290257,  0.097179  ,  1.7000463 ,\n",
       "         0.81872826,  0.71242087,  0.04285157,  0.03726135,  1.37477059],\n",
       "       [ 0.30497505,  2.27137931, -0.12272769,  0.62286325,  0.4187176 ,\n",
       "        -1.18762532, -0.36404034, -0.24399772, -1.89393377,  0.52992839],\n",
       "       [ 0.96036886, -0.68282081,  1.42513161,  1.88947833, -0.81924945,\n",
       "         0.51345203, -0.94568695, -0.65150302, -1.06488207,  0.75674222],\n",
       "       [ 0.47811432,  0.58372252,  2.18786163,  0.09690908,  1.6975419 ,\n",
       "         0.72643963,  0.23948771,  1.11191909, -1.2309983 , -0.98538846],\n",
       "       [-0.8991348 ,  0.412847  , -0.86430856, -0.92793101,  1.57170485,\n",
       "         0.81095546,  1.03627318, -0.52514874,  1.53165462, -0.2301552 ]])"
      ]
     },
     "execution_count": 65,
     "metadata": {},
     "output_type": "execute_result"
    }
   ],
   "source": [
    "G"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 68,
   "metadata": {},
   "outputs": [
    {
     "data": {
      "text/plain": [
       "0.23161402800918465"
      ]
     },
     "execution_count": 68,
     "metadata": {},
     "output_type": "execute_result"
    }
   ],
   "source": [
    "G.mean() #calculate mean"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 69,
   "metadata": {},
   "outputs": [
    {
     "data": {
      "text/plain": [
       "0.9548669662471793"
      ]
     },
     "execution_count": 69,
     "metadata": {},
     "output_type": "execute_result"
    }
   ],
   "source": [
    "G.var() #calculate values"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 71,
   "metadata": {},
   "outputs": [],
   "source": [
    "Ginv = np.linalg.inv(G) #inverse to get the identity matrix"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 72,
   "metadata": {},
   "outputs": [
    {
     "data": {
      "text/plain": [
       "array([[ 0.28582811, -0.26532679,  0.15404397, -0.05174093,  0.27318427,\n",
       "        -0.09724998, -0.17637049,  0.08713172, -0.09468716,  0.07292764],\n",
       "       [ 0.58131437, -0.44892453, -0.5613681 , -0.07256703, -0.22137922,\n",
       "        -0.33518057,  0.32842007,  0.21704985, -0.01571599,  0.70489136],\n",
       "       [ 0.23503517, -0.34008383, -0.35159521, -0.19717544, -0.04150041,\n",
       "        -0.09787134, -0.10128977,  0.13348409,  0.18198791,  0.16068997],\n",
       "       [-0.52725182,  0.67624558, -0.0782561 ,  0.37644587,  0.0468156 ,\n",
       "        -0.38055322,  0.43710099,  0.52776003, -0.00882275,  0.64383367],\n",
       "       [-0.06449359,  0.16939367,  0.27918093, -0.23800833,  0.23698426,\n",
       "         0.16690277, -0.20214318, -0.20198552,  0.26873387, -0.08864916],\n",
       "       [ 0.3486524 , -0.28608288, -0.10720209,  0.07554209, -0.30290033,\n",
       "         0.14855093, -0.07269187,  0.22226954, -0.00363948,  0.12358123],\n",
       "       [-1.16437638,  0.68726027,  0.31853608,  0.81991327,  0.13036353,\n",
       "         0.1018607 ,  0.4921688 ,  0.26619918, -0.28428924,  0.04821012],\n",
       "       [ 0.18603864,  0.00687992, -0.34139754, -0.01667615, -0.08409416,\n",
       "         0.07169632, -0.1604808 , -0.22772826,  0.19680695, -0.1794182 ],\n",
       "       [ 0.59914155, -0.3589165 , -0.59729463, -0.29199511,  0.0256765 ,\n",
       "        -0.46007758, -0.17434726,  0.2025374 ,  0.02014732,  0.85130055],\n",
       "       [ 0.27742557, -0.37916935, -0.20587289, -0.27796034,  0.00353942,\n",
       "         0.57698083, -0.31842558, -0.11026655, -0.07879558, -0.44279412]])"
      ]
     },
     "execution_count": 72,
     "metadata": {},
     "output_type": "execute_result"
    }
   ],
   "source": [
    "Ginv"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 73,
   "metadata": {},
   "outputs": [
    {
     "data": {
      "text/plain": [
       "array([[ 1.00000000e+00, -6.55058755e-17, -2.38477796e-16,\n",
       "         4.00882108e-16, -2.39742556e-16, -1.66896466e-16,\n",
       "        -3.89066741e-16,  1.17360098e-16, -1.07552856e-16,\n",
       "         1.66533454e-16],\n",
       "       [ 7.19365018e-17,  1.00000000e+00, -3.91978514e-16,\n",
       "         1.57722398e-16, -2.72531146e-16, -7.64660599e-17,\n",
       "        -9.01474116e-17, -3.94650594e-16,  1.11022302e-16,\n",
       "         0.00000000e+00],\n",
       "       [ 1.08369931e-16, -2.40046019e-16,  1.00000000e+00,\n",
       "         6.96461319e-17, -9.45332240e-17,  1.61480867e-17,\n",
       "        -1.75115401e-17, -6.45096177e-17,  1.94289029e-16,\n",
       "         9.71445147e-17],\n",
       "       [ 2.74045740e-16, -2.33743463e-16, -1.90441393e-18,\n",
       "         1.00000000e+00,  5.10374751e-17,  4.58674457e-16,\n",
       "         3.09779351e-16,  4.58252223e-16,  1.66533454e-16,\n",
       "        -5.27355937e-16],\n",
       "       [-5.90689472e-17, -6.41625839e-17,  2.45421110e-17,\n",
       "        -1.15253382e-16,  1.00000000e+00, -1.92272516e-17,\n",
       "        -1.07027081e-17,  9.86973581e-17,  1.11022302e-16,\n",
       "        -5.55111512e-17],\n",
       "       [ 4.06933178e-17, -4.23166266e-17, -1.40951535e-16,\n",
       "         1.20825746e-16, -5.53024421e-17,  1.00000000e+00,\n",
       "        -2.46807598e-17, -1.36300561e-16, -4.85722573e-17,\n",
       "        -1.24900090e-16],\n",
       "       [ 1.23375883e-16, -3.21696613e-17,  9.89027009e-17,\n",
       "        -5.41085342e-16,  1.83924167e-16,  6.99999015e-16,\n",
       "         1.00000000e+00,  6.80410568e-16,  5.55111512e-17,\n",
       "        -3.88578059e-16],\n",
       "       [ 6.47168053e-18,  1.14206806e-16, -2.51054652e-17,\n",
       "         7.72489464e-17,  3.82697784e-17, -8.18186113e-17,\n",
       "         4.64424970e-17,  1.00000000e+00, -4.85722573e-17,\n",
       "         2.60208521e-17],\n",
       "       [ 2.77615248e-16, -1.28438885e-16, -1.09070814e-16,\n",
       "         1.43873299e-16, -4.42888054e-16, -2.99410058e-16,\n",
       "        -3.86132521e-16, -3.61805056e-16,  1.00000000e+00,\n",
       "        -1.11022302e-16],\n",
       "       [-3.58011805e-17,  1.53548030e-16,  2.06296695e-17,\n",
       "         5.09160521e-17,  4.86827497e-17, -1.17592162e-16,\n",
       "         1.98813865e-16, -2.21594574e-16, -5.55111512e-17,\n",
       "         1.00000000e+00]])"
      ]
     },
     "execution_count": 73,
     "metadata": {},
     "output_type": "execute_result"
    }
   ],
   "source": [
    "Ginv.dot(G) #identity matrix "
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 74,
   "metadata": {},
   "outputs": [
    {
     "data": {
      "text/plain": [
       "array([[ 1.00000000e+00, -1.36027920e-16, -5.53423260e-18,\n",
       "        -9.01809365e-17, -5.09359406e-17, -1.32337111e-16,\n",
       "         1.39108910e-16,  6.76846552e-17,  0.00000000e+00,\n",
       "         2.22044605e-16],\n",
       "       [ 2.17647176e-16,  1.00000000e+00,  2.10928339e-17,\n",
       "         2.44982529e-16, -7.38523662e-17, -6.02428002e-17,\n",
       "        -9.91323367e-17, -3.07515327e-16,  6.93889390e-17,\n",
       "        -2.22044605e-16],\n",
       "       [ 2.03277803e-16, -4.24980818e-17,  1.00000000e+00,\n",
       "        -2.38532906e-16, -4.39807397e-17,  4.88130851e-17,\n",
       "        -7.71696894e-17, -2.82575281e-18,  1.66533454e-16,\n",
       "        -5.55111512e-17],\n",
       "       [ 8.24165730e-17,  7.19869231e-17, -5.85755975e-17,\n",
       "         1.00000000e+00, -1.49087385e-16,  2.18539131e-17,\n",
       "         5.06997817e-17,  8.60046254e-17,  5.55111512e-17,\n",
       "        -2.42861287e-17],\n",
       "       [ 1.59908235e-16, -4.11501502e-18, -6.37694633e-17,\n",
       "        -1.44006257e-18,  1.00000000e+00, -1.08917528e-16,\n",
       "        -7.77836318e-17, -3.73148119e-17, -2.77555756e-17,\n",
       "         0.00000000e+00],\n",
       "       [-3.26139227e-16,  7.45371877e-17,  2.18872127e-16,\n",
       "         3.13638705e-16, -4.67725407e-17,  1.00000000e+00,\n",
       "         2.04899855e-16, -1.40193041e-17, -6.93889390e-17,\n",
       "         1.38777878e-16],\n",
       "       [-1.13955798e-16,  2.39056488e-16,  1.97832627e-16,\n",
       "         1.53172934e-17, -5.63806496e-17,  1.30606735e-16,\n",
       "         1.00000000e+00, -8.84378046e-18, -2.77555756e-17,\n",
       "        -2.22044605e-16],\n",
       "       [-4.91075602e-17,  1.50947368e-16,  1.22719474e-16,\n",
       "         3.92362016e-16,  2.27663540e-17, -1.01947049e-17,\n",
       "        -9.24965260e-17,  1.00000000e+00, -8.32667268e-17,\n",
       "        -1.11022302e-16],\n",
       "       [-9.24571987e-17,  5.35627889e-17, -3.94741446e-17,\n",
       "         6.20154954e-17,  2.87041301e-18,  7.69883414e-17,\n",
       "        -2.38496297e-16, -8.44271090e-17,  1.00000000e+00,\n",
       "         0.00000000e+00],\n",
       "       [-1.70535436e-17, -5.89863121e-17,  1.48390187e-16,\n",
       "         4.37277687e-17,  1.18935473e-16, -1.47386842e-16,\n",
       "        -7.51771939e-17, -5.66889999e-17, -8.32667268e-17,\n",
       "         1.00000000e+00]])"
      ]
     },
     "execution_count": 74,
     "metadata": {},
     "output_type": "execute_result"
    }
   ],
   "source": [
    "G.dot(Ginv) #identity matrix"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 75,
   "metadata": {},
   "outputs": [
    {
     "data": {
      "text/plain": [
       "1012.8726455765376"
      ]
     },
     "execution_count": 75,
     "metadata": {},
     "output_type": "execute_result"
    }
   ],
   "source": [
    "np.linalg.det(G) #matrix determinant"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 76,
   "metadata": {},
   "outputs": [
    {
     "data": {
      "text/plain": [
       "array([ 1.5897517 , -0.32940263, -0.43442778, -0.59376159,  0.7303574 ,\n",
       "        0.81872826, -0.36404034, -0.65150302, -1.2309983 , -0.2301552 ])"
      ]
     },
     "execution_count": 76,
     "metadata": {},
     "output_type": "execute_result"
    }
   ],
   "source": [
    "np.diag(G) #diagonal elements in a vector"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 77,
   "metadata": {},
   "outputs": [
    {
     "data": {
      "text/plain": [
       "array([[1, 0],\n",
       "       [0, 2]])"
      ]
     },
     "execution_count": 77,
     "metadata": {},
     "output_type": "execute_result"
    }
   ],
   "source": [
    "np.diag([1,2]) "
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 83,
   "metadata": {},
   "outputs": [
    {
     "data": {
      "text/plain": [
       "array([[ 1,  5,  6,  8],\n",
       "       [ 6, 30, 36, 48],\n",
       "       [ 5, 25, 30, 40],\n",
       "       [ 8, 40, 48, 64]])"
      ]
     },
     "execution_count": 83,
     "metadata": {},
     "output_type": "execute_result"
    }
   ],
   "source": [
    "np.outer(M.T,M)"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 82,
   "metadata": {},
   "outputs": [
    {
     "data": {
      "text/plain": [
       "matrix([[31, 54],\n",
       "        [45, 94]])"
      ]
     },
     "execution_count": 82,
     "metadata": {},
     "output_type": "execute_result"
    }
   ],
   "source": [
    "np.inner(M.T,M)"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 84,
   "metadata": {},
   "outputs": [
    {
     "data": {
      "text/plain": [
       "matrix([[ 26,  46],\n",
       "        [ 46, 100]])"
      ]
     },
     "execution_count": 84,
     "metadata": {},
     "output_type": "execute_result"
    }
   ],
   "source": [
    "M.dot(M.T) #matrix multiplication"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 85,
   "metadata": {},
   "outputs": [
    {
     "data": {
      "text/plain": [
       "9"
      ]
     },
     "execution_count": 85,
     "metadata": {},
     "output_type": "execute_result"
    }
   ],
   "source": [
    "np.diag(M).sum()"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 86,
   "metadata": {},
   "outputs": [
    {
     "data": {
      "text/plain": [
       "9"
      ]
     },
     "execution_count": 86,
     "metadata": {},
     "output_type": "execute_result"
    }
   ],
   "source": [
    "np.trace(M)"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 87,
   "metadata": {},
   "outputs": [],
   "source": [
    "S = np.random.randn(100,3) #synthetic random data with 100 samples and 3 features"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 89,
   "metadata": {},
   "outputs": [],
   "source": [
    "cov = np.cov(S.T)"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 90,
   "metadata": {},
   "outputs": [
    {
     "data": {
      "text/plain": [
       "array([[ 0.95675393,  0.12379465, -0.10341418],\n",
       "       [ 0.12379465,  0.85072146,  0.05913774],\n",
       "       [-0.10341418,  0.05913774,  1.02266856]])"
      ]
     },
     "execution_count": 90,
     "metadata": {},
     "output_type": "execute_result"
    }
   ],
   "source": [
    "cov # to calculate coveriance of a marix, we need to transpose it first"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 91,
   "metadata": {},
   "outputs": [
    {
     "data": {
      "text/plain": [
       "(3, 3)"
      ]
     },
     "execution_count": 91,
     "metadata": {},
     "output_type": "execute_result"
    }
   ],
   "source": [
    "cov.shape"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 92,
   "metadata": {},
   "outputs": [
    {
     "data": {
      "text/plain": [
       "(array([0.72928106, 0.99882464, 1.10203824]),\n",
       " array([[-0.56550985,  0.50263468,  0.65387842],\n",
       "        [ 0.746851  ,  0.6484341 ,  0.14746798],\n",
       "        [-0.34987454,  0.57174435, -0.74208908]]))"
      ]
     },
     "execution_count": 92,
     "metadata": {},
     "output_type": "execute_result"
    }
   ],
   "source": [
    "np.linalg.eigh(cov)# eigenvalues for symmetric and hermitian matrix"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 93,
   "metadata": {},
   "outputs": [
    {
     "data": {
      "text/plain": [
       "(array([0.72928106, 1.10203824, 0.99882464]),\n",
       " array([[ 0.56550985, -0.65387842,  0.50263468],\n",
       "        [-0.746851  , -0.14746798,  0.6484341 ],\n",
       "        [ 0.34987454,  0.74208908,  0.57174435]]))"
      ]
     },
     "execution_count": 93,
     "metadata": {},
     "output_type": "execute_result"
    }
   ],
   "source": [
    "np.linalg.eig(cov) #regular eig and eigh gives the same in this case but possible to get others"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 95,
   "metadata": {},
   "outputs": [],
   "source": [
    "np.linalg.inv(M.T).dot(M) #there is a better way to do this with solve"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 98,
   "metadata": {},
   "outputs": [
    {
     "data": {
      "text/plain": [
       "matrix([[ 1.27272727,  0.36363636],\n",
       "        [-0.04545455,  0.77272727]])"
      ]
     },
     "execution_count": 98,
     "metadata": {},
     "output_type": "execute_result"
    }
   ],
   "source": [
    "np.linalg.solve(M.T, M) #get the same answer as above"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": null,
   "metadata": {},
   "outputs": [],
   "source": []
  }
 ],
 "metadata": {
  "kernelspec": {
   "display_name": "Python 3",
   "language": "python",
   "name": "python3"
  },
  "language_info": {
   "codemirror_mode": {
    "name": "ipython",
    "version": 3
   },
   "file_extension": ".py",
   "mimetype": "text/x-python",
   "name": "python",
   "nbconvert_exporter": "python",
   "pygments_lexer": "ipython3",
   "version": "3.7.2"
  }
 },
 "nbformat": 4,
 "nbformat_minor": 2
}
