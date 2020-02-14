import torch
from data import *
from MLP import *
import random
from torch.autograd import Variable
# ------------------------------------------------------------------------------
# for selecting (source, data) in random ways
def random_choice(l):
    return l[random.randint(0, len(l) - 1)]
# ------------------------------------------------------------------------------
# select random data and
# initialize as variable
def randomTrainingPair():
    # yo = random_choice(all_y)
    # xo = random_choice(Xo_in_Yo[yo])
    # yo = Variable(torch.LongTensor([all_y.index(yo)]))
    # xo = Variable(xo)
    # ---------------------------------------------------
    i_ = random_choice(runs_)
    yo = Yo[i_,:]
    xo = Xo[i_,:]
    yo = Variable(yo)
    xo = Variable(xo)
    # yo = yo[None,:]
    xo = xo[None,:]
    return yo, xo
# ------------------------------------------------------------------------------
# build mlp, 
# init optimizer & objective function
# ------------------------------------------------------------------------------
n_epochs = 5000
lr       = 0.1
mmtum    = 0.01 
# ------------------------------------------------------------------------------
mlp = MLP(nx, ny, Xo,Yo )
optimizer = torch.optim.SGD(mlp.parameters(), lr=lr,momentum=mmtum)
# criterion = nn.MSELoss()
criterion = nn.L1Loss()
# ------------------------------------------------------------------------------
# train
# ------------------------------------------------------------------------------
def train(yo, xo):
    # --------------
    # set gradient to zero
    # --------------
    optimizer.zero_grad()
    # --------------
    # run fwd model
    # --------------
    y = mlp(xo)
    # --------------
    # error & objective fnc
    # --------------
    # yo=yo.float()
    loss = criterion(y,yo)
    # --------------
    # error backpropagation
    # computes gradient update
    # --------------
    loss.backward()
    # --------------
    # update
    # --------------
    optimizer.step()
    return loss.item()
# ------------------------------------------------------------------------------
# Keep track of losses for plotting
current_loss = 0
all_losses = []
# ------------------------------------------------------------------------------
#                               main loop
# ------------------------------------------------------------------------------
for epoch in range(0, n_epochs - 1):
    yo, xo = randomTrainingPair()
    loss = train(yo, xo)
    all_losses.append(loss)
# ------------------------------------------------------------------------------
print('Finished Training')
print(all_losses[0],all_losses[len(all_losses)-1])
# ------------------------------------------------------------------------------
i_=1
xo = Xo[i_,:]
xo = xo[None,:]
y = mlp(xo)
y.t()
print('\n what this thing thinks it is\n',y,'\n')
yo = Yo[i_,:]
yo = yo[None,:]
yo = yo.t()
print('\n what it actually is         \n',yo,'\n')
# ------------------------------------------------------------------------------
path_='../machines/'
torch.save(mlp, path_+'i-am-a-mlp-machine.pt')

