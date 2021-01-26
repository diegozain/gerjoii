import sys
sys.path.append('../../../../../src/shared/graphics/graphics_py/')
from fancy_figure import fancy_figure
import torch
from data import *
from MLP import *
import random
# ------------------------------------------------------------------------------
n_epochs = 5000
lr       = 0.01
mmtum    = 0.005
# ------------------------------------------------------------------------------
print(' the current step size is ',lr)
change = input(' do you want to change step size? (y if yes) ')
change = str(change)
if change=='y':
    lr = input(' tell me new step size: ')
    lr = float(lr)

print('\n the current momentum  is ',mmtum)
change = input(' do you want to change momentum? (y if yes) ')
change = str(change)
if change=='y':
    mmtum = input(' tell me new momentum: ')
    mmtum = float(mmtum)
# ------------------------------------------------------------------------------
torch.manual_seed(0)
random.seed()
# ------------------------------------------------------------------------------
size=[4,4]
dpi=200
guarda_path='../pics/'
# ------------------------------------------------------------------------------
# for selecting (source, data) in random ways
def random_choice(l):
    return l[random.randint(0, len(l) - 1)]
# ------------------------------------------------------------------------------
# select random data and
# initialize as variable
def randomTrainingPair():
    i_ = random_choice(runs_)
    yo = Yo[i_,:]
    xo = Xo[i_,:]
    yo = torch.autograd.Variable(yo)
    xo = torch.autograd.Variable(xo)
    xo = xo[None,:]
    return yo, xo
# ------------------------------------------------------------------------------
# build mlp, 
# init optimizer & objective function
# ------------------------------------------------------------------------------
mlp = MLP(nx, ny, Xo,Yo )
# ------------------------------------------------------------------------------
optimizer = torch.optim.SGD(mlp.parameters(), lr=lr,momentum=mmtum)
# optimizer = torch.optim.Adadelta(mlp.parameters(), lr=lr, rho=0.9, eps=1e-06, weight_decay=0)
# ------------------------------------------------------------------------------
# criterion = torch.nn.MSELoss()
criterion = torch.nn.L1Loss()
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
losses = []
# ------------------------------------------------------------------------------
#                               main loop
# ------------------------------------------------------------------------------
for epoch in range(0, n_epochs - 1):
    yo, xo = randomTrainingPair()
    loss = train(yo, xo)
    losses.append(loss)
# ------------------------------------------------------------------------------
print('Finished Training')
print(losses[0],losses[len(losses)-1])

fancy_figure(figsize=size,
x=np.arange(1,len(losses)+1),
curve=losses,
symbol='o-',
colop='k',
title='Loss history',
xlabel=r'Iteration \#',
ylabel=r'Value',
margin=(0.05,0.05),
guarda_path=guarda_path,
guarda=dpi,
fig_name='loss'
).plotter()
# ------------------------------------------------------------------------------
i_=0
xo = Xo[i_,:]
xo = xo[None,:]
y = mlp(xo)
y.t()
print('\n what this thing thinks it is for the first inversion run \n\n',y,'\n')
yo = Yo[i_,:]
yo = yo[None,:]
yo = yo.t()
print('\n what it actually is         \n\n',yo,'\n')
# ------------------------------------------------------------------------------
y=y.detach().numpy()
yo=yo.numpy()
# ------------------------------------------------------------------------------
fancy_figure(
figsize=size,
x=np.arange(1,y.size+1),
curve=yo,
symbol='o-',
colop='k',
holdon='on'
).plotter()
# ------------------------------------------------------------------------------
fancy_figure(
figsize=size,
curve=np.zeros(y.size),
symbol='--',
colop=(0.8,0.8,0.8),
margin=(0.05,0.05),
holdon='on'
).plotter()	
# ------------------------------------------------------------------------------
fancy_figure(
figsize=size,
x=np.arange(1,yo.size+1),
curve=y,
symbol='o-',
colop='r',
title='Inversion parameters 1st run',
xlabel=r'Parameter \#',
ylabel=r'Value',
margin=(0.05,0.05),
legends= ['true','estimated'],
guarda_path=guarda_path,
guarda=dpi,
fig_name='true_esti'
).plotter()
# ------------------------------------------------------------------------------
save_ = input(" Do you want to save the learning machine (y or n):  ")
if save_=='y':
    path_='../machines/'
    torch.save(mlp, path_+'i-am-a-mlp-machine.pt')
    print('ok, saved.')
print('\n')
# ------------------------------------------------------------------------------

