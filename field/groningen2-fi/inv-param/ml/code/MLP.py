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
# ------------------------------------------------------------------------------
class MLP(torch.nn.Module):
    def __init__(self, x_size, y_size, X=None, Y=None):
        super(MLP, self).__init__()
        # ----------------------------------
        self.x_size   = x_size
        self.y_size   = y_size
        # ----------------------------------
        if (X is None) or (Y is None):
            self.W = torch.nn.Linear(x_size , y_size)
        elif (X is not None) and (Y is not None):
            self.W = self.init_W(X,Y)
        # ----------------------------------
        self.linear1 = torch.nn.Linear(y_size , y_size)
        self.linear2 = torch.nn.Linear(y_size , y_size)
        # self.linear3 = torch.nn.Linear(y_size , y_size)
        # self.linear4 = torch.nn.Linear(y_size , y_size)
        # ----------------------------------
        self.sigmi = torch.nn.Sigmoid()
        self.relu  = torch.nn.ReLU()
        self.tanh  = torch.nn.Tanh()
        # ----------------------------------
    def forward(self, x):
        # ----------------------------------
        W = self.W
        x = torch.mm(x,W)
        x = x.float()
        # --
        x = self.sigmi(x)
        x = self.linear1(x)
        # # --
        # x = self.tanh(x)
        # x = self.linear2(x)
        # # --
        # x = self.sigmi(x)
        # x = self.linear3(x)
        # # --
        # x = self.sigmi(x)
        # x = self.linear4(x)
        # --
        x = x.squeeze().t()
        # --
        # x = self.relu(x)
        # --
        # x[0] = self.sigmi(x[0])     # beta_dc
        # x[1] = self.sigmi(x[1])     # momentum_dc
        # # x[2] = self.sigmi(x[2])     # g_e_weight
        # # x[3] = self.sigmi(x[3])     # g_s_weight
        # x[4] = self.sigmi(x[4])     # adc_
        # # x[5] = self.relu(x[5])    # da_dc
        # # x[6] = self.relu(x[6])    # dEdc
        # # x[7] = self.relu(x[7])    # da_w
        # # x[8] = self.relu(x[8])    # dEw
        # # x[9] = self.relu(x[9])    # h_eps
        # # x[10] = self.relu(x[10])    # d_eps
        # # x[11] = self.relu(x[11])    # h_sig
        # # x[12] = self.relu(x[12])    # d_sig
        # # x[13] = self.sigmi(x[13]) # step_
        # --
        x[0] = self.sigmi(x[0])     # g_e_weight
        x[1] = self.sigmi(x[1])     # g_s_weight
        x[2] = self.sigmi(x[2])     # adc_
        # x[3] = self.relu(x[3])    # da_dc
        # x[4] = self.relu(x[4])    # dEdc
        # x[5] = self.relu(x[5])    # da_w
        # x[6] = self.relu(x[6])    # dEw
        # x[7] = self.relu(x[7])    # h_eps
        # x[8] = self.relu(x[8])    # d_eps
        # x[9] = self.relu(x[9])    # h_sig
        # x[10] = self.relu(x[10])    # d_sig
        # x[11] = self.sigmi(x[11]) # step_
        # --
        return x.double()
    def init_W(self,X,Y):
        # ----------------------------------
        XX = torch.mm(torch.t(X) , X)
        Y  = torch.mm(torch.t(X) , Y)
        W,_= torch.solve(Y , XX)
        W = torch.autograd.Variable(W,requires_grad=True)
        return W
# ------------------------------------------------------------------------------
