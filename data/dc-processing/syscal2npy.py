'''
    READ IRIS Syscal Pro or Elrec Pro file
    
    ported in from pybert, 
    which was ported from the matlab version (from Tobias Pfaff, Uni Heidelberg)
    the matlab version is not in the internet :( 
'''
import struct
import numpy as np
import os

project_  = input("project name                  : ")
data_name = input("data name (no .bin extention) : ")

# data_name ='sandbar'

path_ = "../raw/"+project_+"/dc-data/"
data_name_ = path_+data_name+'.bin'

with open(data_name_, 'rb') as fi:
    readData = fi.read()

    # Filesize: 1029 (bytes header) + nBlocks * 304 (bytes per block)
    nBlocks = (len(readData) - 1029) / 304.0

    if nBlocks > 0 and (nBlocks == round(nBlocks)):
        headerIdentification = str(readData[0:20])

        if 'Pro' not in headerIdentification and False:
            raise Exception('This is probably no SYSCAL Pro data file: ' +
                            data_name_ + " : " + headerIdentification)

        measureingTime = readData[20:40]
        print('this data was acquired:  ',measureingTime)

        startBlock = 1029  # hex 404
    else:
        raise Exception('Size of the SYSCAL Pro data file is not valid: ' +
                        data_name_ + " : " + str(len(readData)) + " ; " +
                        str(nBlocks))

    # the file size and header seems to be ok. start parsing.
    nBlocks = int(nBlocks)
    
    # xyz data
    a_xyz = np.zeros((nBlocks,3))
    b_xyz = np.zeros((nBlocks,3))
    m_xyz = np.zeros((nBlocks,3))
    n_xyz = np.zeros((nBlocks,3))
    # Main data
    sp = np.zeros(nBlocks)  # self potential
    vp = np.zeros(nBlocks)  # voltage difference
    rho = np.zeros(nBlocks)  # apparent resistivity
    curr = np.zeros(nBlocks)  # injected current
    gm = np.zeros(nBlocks)  # global chargeability
    std = np.zeros(nBlocks)  # std. deviation
    # Auxiliary data
    stacks = np.zeros(nBlocks)  # number of stacks measured
    rs_check = np.zeros(nBlocks)  # rs_check reception dipole
    vab = np.zeros(nBlocks)  # absolute injected voltage
    bat_tx = np.zeros(nBlocks)  # tx battery voltage
    bat_rx = np.zeros(nBlocks)  # rx battery voltage
    temp = np.zeros(nBlocks)  # temperature

    for i in range(nBlocks):
        block = readData[startBlock:startBlock+304]
        # short(max cycles) , short(min cycles), float32(measurement time),
        # float32(delay for measurement)
        [maxCyles, minCycles, measTime, delayTime, unKnownInt] = \
            struct.unpack_from('hhffi', block, offset=0)  # 16 byte

        # Read electrode positions for each data
        # (C1_x C2_x P1_x P2_x C1_y C2_y P1_y P2_y C1_z C2_z P1_z P2_z)
        ePos = struct.unpack_from('ffff ffff ffff', block, offset=16)
        if (ePos[0] < 99999.99):
            a_xyz[i,:] = np.array([ePos[0], ePos[4], ePos[8]])
        if (ePos[1] < 99999.99):
            b_xyz[i,:] = np.array([ePos[1], ePos[5], ePos[9]])
        if (ePos[2] < 99999.99):
            m_xyz[i,:] = np.array([ePos[2], ePos[6], ePos[10]])
        if (ePos[3] < 99999.99):
            n_xyz[i,:] = np.array([ePos[3], ePos[7], ePos[11]])

        # Read data float32 (sp, vp, in, rho, gm, std)
        [sp[i], vp[i], curr[i], rho[i], gm[i], std[i]] = \
            struct.unpack_from('fff fff', block, offset=64)

        # Read auxiliary information
        [stacks[i], rs_check[i], vab[i], bat_tx[i], bat_rx[i], temp[i]] = \
            struct.unpack_from('ffffff', block, offset=272)

        startBlock += 304
    # END for each data block
    
    data = np.zeros((nBlocks,25))
    
    data[:,0:3] = a_xyz
    data[:,3:6] = b_xyz
    data[:,6:9] = m_xyz
    data[:,9:12] = n_xyz
    
    data[:,12] = sp             # self potential (V)
    data[:,13] = vp * 1e-3      # measured voltage (V)
    data[:,14] = curr * 1e-3    # injected current (A)
    data[:,15] = rho            # apparent resistivity from syscal ( ? )
    data[:,16] = gm             # chargeability (mV/V)
    data[:,17] = gm             # chargeability (mV/V). Meant to be induced p.
    data[:,18] = std            # standard deviation (tenths of percent)
    data[:,19] = stacks         # stacks
    data[:,20] = rs_check       # rs check
    data[:,21] = vab            # injected voltage (V)
    data[:,22] = bat_tx         # battery voltage (V)
    data[:,23] = bat_rx         # battery voltage (V)
    data[:,24] = temp           # temperature (C)
    
    data_name_ = path_+data_name+'.npy'
    np.save(data_name_, data)
    
    # write data to disk
    
    os.chdir(path_+"data-mat-raw/")
    os.system('touch abmn.txt')
    
    abmn = np.zeros((nBlocks,4))
    abmn[:,0] = a_xyz[:,0]
    abmn[:,1] = b_xyz[:,0]
    abmn[:,2] = m_xyz[:,0]
    abmn[:,3] = n_xyz[:,0]
    
    np.save('voltages.npy', vp*1e-3)
    np.save('currents.npy', curr*1e-3)
    np.save('std.npy', std)
    np.save('self_pot.npy', sp)
    np.save('app_resi.npy', rho)
    
    np.savetxt('abmn.txt', abmn)
    
    print('\n ok, done. data is in\n', path_+"data-mat-raw/")

