from pylab import *

# A=fromfile('/home/user/data3', sep='\n')
B=fromfile('100', sep='\n')
C=fromfile('50', sep='\n')
D=fromfile('25', sep='\n')
E=fromfile('10', sep='\n')
# F=fromfile('/home/user/15', sep='\n')
# G=fromfile('/home/user/30', sep='\n')


# X=fromfile('/home/user/data2', sep='\n')
# Y=fromfile('/home/user/data', sep='\n')

Z=fromfile('standalone', sep='\n')
# hist(G,bins=10000, density=True, cumulative=True,
#          histtype='step', label="30 ms")


# hist(F,bins=10000, density=True, cumulative=True,
#          histtype='step', label="15 ms")

hist(E,bins=10000, density=True, cumulative=True,
         histtype='step', label="10 ms, Packet Loss = 0%")

hist(D,bins=10000, density=True, cumulative=True,
         histtype='step', label="25 ms, Packet Loss = 0%")

hist(C,bins=100000, density=True, cumulative=True,
         histtype='step', label="50 ms, Packet Loss = 1%")

hist(B,bins=100000, density=True, cumulative=True,
         histtype='step', label="100 ms, Packet Loss = 2%")

# hist(A,bins=10000, density=True, cumulative=True,
#          histtype='step', label="150 ms")



# hist(X,bins=100000, density=True, cumulative=True,
#          histtype='step', label= "500 ms")

# hist(Y,bins=100000, density=True, cumulative=True,
#          histtype='step', label ="1 seconds")

hist(Z,bins=100000, density=True, cumulative=True,
         histtype='step', label= "default, Packet Loss = 0.4%")

# axhline(y=0.9)
xticks(arange(1001,step=100,dtype=int))
yticks(arange(0,1.1,step=0.1))
legend(loc=4)
xlim(xmin=0,xmax=1000)
ylim(ymin=0, ymax=1)
xlabel('RTT in ms')
ylabel('CDF')
grid()
# show()
savefig('comparison.png', papertype='a4', dpi=300)
