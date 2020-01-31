# ------------------------------------------------------------------------------
# multi-layer perceptron class
# ------------------------------------------------------------------------------
# defines a learning machine with the mlp architecture:
# 
# y = W * x
# y = H * y   | these 
# y = f(y)    | loop n_hidden times
# 
# x is input
# y is output
# ------------------------------------------------------------------------------
import torch
import torch.nn as nn
import torch.nn.functional as F
from torch.autograd import Variable
# ------------------------------------------------------------------------------
class MLP(nn.Module):
    def __init__(self, x_size, y_size, X=None, Y=None):
        super(MLP, self).__init__()
        # ----------------------------------
        self.x_size   = x_size
        self.y_size   = y_size
        # ----------------------------------
        if (X is None) or (Y is None):
            self.W = nn.Linear(x_size , y_size)
        elif (X is not None) and (Y is not None):
            self.W = self.init_W(X,Y)
        # ----------------------------------
        self.linear1 = nn.Linear(y_size , y_size)
        self.linear2 = nn.Linear(y_size , y_size)
        # self.linear3 = nn.Linear(y_size , y_size)
        # self.linear4 = nn.Linear(y_size , y_size)
        # self.linear5 = nn.Linear(y_size , y_size)
        # ----------------------------------
        self.sigmi = nn.Sigmoid()
        # ----------------------------------
    def forward(self, x):
        # ----------------------------------
        W = self.W
        x = torch.mm(x,W)
        x = x.float()
        # --
        # x = F.relu(x)
        x = self.sigmi(x)
        x = self.linear1(x)
        # --
        # x = F.relu(x)
        x = self.sigmi(x)
        x = self.linear2(x)
        # --
        x = x.squeeze().t()
        # --
        # x[0] = self.sigmi(x[0])
        # # x[1] = self.threshi(x)
        # # x[2] = self.threshi(x)
        # # x[3] = self.threshi(x)
        # x[4] = self.sigmi(x[4])
        # x[5] = self.sigmi(x[5])
        # x[6] = self.sigmi(x[6])
        # x[7] = self.sigmi(x[7])
        # x[8] = self.sigmi(x[8])
        # x[9] = self.sigmi(x[9])
        # x[10] = self.sigmi(x[10])
        return x.double()
    def init_W(self,X,Y):
        # ----------------------------------
        XX = torch.mm(torch.t(X) , X)
        Y  = torch.mm(torch.t(X) , Y)
        W , _ = torch.solve(Y , XX)
        # W = nn.Parameter(W)
        W = Variable(W,requires_grad=True)
        return W