#!/usr/bin/env python
# coding: utf-8

# # Python lesson plans

# Variable assignment conventions: 
# - Not permitted: variables cannot start with numbers, can't use operators, spaces, slash, ., ?, !, $, #
# - Permitted: letters, digits only after letters, underscores

# In[17]:


var = 2 # variables sart with lower letter


# In[18]:


var


# In[19]:


Array1 = [1,2,3] #array list


# In[20]:


Array1


# In[21]:


2*Array1


# In[27]:


Array2 = ([1,2],[3,4])


# In[28]:


Array2


# In[29]:


Array2 + Array2


# In[23]:


A_B = 1


# In[24]:


A_B

family_member_names = [] #kebab case
# In[26]:


print (family_member_names)


# Conditional statement conventions: 
# - If else do not go into paranthesis, curly brackets or square brackes are not used
# - Note spaces and indentations 

# In[27]:


if var == 1: 
    print("var is 1")
else : 
    print("var is not 1")
    


# In[30]:


print ("1")
print ("2")
print ("3")
print ("1, 2, 3")


# In[29]:


print ("1, 2, 3")


# For loop conventions:  
# - for is a keyword among a few others in python
# - explore arrays using 'for' loops or 'while'

# In[31]:


for i in Array1:
    print(i)
    


# In[1]:


i = 15
while i>10:
    print(i)
    i = i-1
    


# # This is a lesson plan for numpy 

# Intro to numpy features:
# - arrays, vectors, and matrices
# - matrix multiplications
# - eigen values and eigen vectors
# - solving linear systems

# In[3]:


import numpy as np


# In[4]:


Array = np.array([1,2,3])


# In[5]:


Array


# In[6]:


for e in Array:
    print (e)


# In[11]:


Array + Array


# In[12]:


2* Array


# In[40]:


np.sqrt(Array) #square root of array2


# In[41]:


np.log(Array) #log of array2


# In[42]:


np.exp(Array) #exponential of array2


# In[43]:


np.sum(Array)


# In[44]:


np.linalg.norm(Array)


# In[46]:


M = np.matrix([[1,5], [6,8]])


# In[47]:


M


# In[49]:


A = np.array(M)


# In[50]:


A


# In[51]:


A.T #use T for transpose


# In[52]:


Z = np.zeros(11) #generate an array


# In[54]:


Z


# In[57]:


Z = np.zeros((11,11)) #generate a marix of zeros


# In[60]:


Z


# In[58]:


X = np.ones((10,10)) #generate a marix of ones


# In[59]:


X


# In[62]:


Y = np.random.random((10,10))


# In[63]:


Y


# In[64]:


G = np.random.randn(10,10)


# In[65]:


G


# In[68]:


G.mean() #calculate mean


# In[69]:


G.var() #calculate values


# In[71]:


Ginv = np.linalg.inv(G) #inverse to get the identity matrix


# In[72]:


Ginv


# In[73]:


Ginv.dot(G) #identity matrix 


# In[74]:


G.dot(Ginv) #identity matrix


# In[75]:


np.linalg.det(G) #matrix determinant


# In[76]:


np.diag(G) #diagonal elements in a vector


# In[77]:


np.diag([1,2]) 


# In[83]:


np.outer(M.T,M)


# In[82]:


np.inner(M.T,M)


# In[84]:


M.dot(M.T) #matrix multiplication


# In[85]:


np.diag(M).sum()


# In[86]:


np.trace(M)


# In[87]:


S = np.random.randn(100,3) #synthetic random data with 100 samples and 3 features


# In[89]:


cov = np.cov(S.T)


# In[90]:


cov # to calculate coveriance of a marix, we need to transpose it first


# In[91]:


cov.shape


# In[92]:


np.linalg.eigh(cov)# eigenvalues for symmetric and hermitian matrix


# In[93]:


np.linalg.eig(cov) #regular eig and eigh gives the same in this case but possible to get others


# In[99]:


np.linalg.inv(M.T).dot(M) #there is a better way to do this with solve


# In[98]:


np.linalg.solve(M.T, M) #get the same answer as above, always use solve not inverse


# In[ ]:




