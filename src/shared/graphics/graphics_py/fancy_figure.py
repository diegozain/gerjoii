import matplotlib
import types
matplotlib.use("TkAgg")
# -----------------------
# diego domenzain
# Boise State University 
# spring 2019
# -----------------------
class fancy_figure():
    def __init__(self, **kwargs):
        '''
        plotting fancy
        '''
        self.kwargs  = kwargs
        # ......
        # hold on
        # ......
        self.plt_   = kwargs.get('plt_', None)
        self.holdon = kwargs.get('holdon', 'off')
        self.ax_    = kwargs.get('ax_', None)
        self.overlay   = kwargs.get('overlay','false')
        # ......
        # text
        # ......
        self.title   = kwargs.get('title', None)
        self.xlabel  = kwargs.get('xlabel', None)
        self.ylabel  = kwargs.get('ylabel', None)
        self.fig_num = kwargs.get('fig_num', None)
        self.colo_accu = kwargs.get('colo_accu',"%g")
        self.colo_title = kwargs.get('colo_title',"")
        self.legends = kwargs.get('legends', None)
        self.yticks = kwargs.get('yticks', None)
        self.xticks = kwargs.get('xticks', None)
        self.legend_coord = kwargs.get('legend_coord',None)
        self.super_title  = kwargs.get('super_title',None)
        # ......
        # data
        # ......
        self.data    = kwargs.get('data',None)
        self.curve   = kwargs.get('curve',None)
        self.x       = kwargs.get('x',None)
        self.y       = kwargs.get('y',None)
        self.extent  = kwargs.get('extent',None)
        self.v = kwargs.get('v',None)
        self.theta = kwargs.get('theta',None)
        self.xlim    = kwargs.get('xlim',None)
        self.ylim    = kwargs.get('ylim',None)
        # ......
        # decorations
        # ......
        self.figsize = kwargs.get('figsize',None)
        self.x_ticklabels = kwargs.get('x_ticklabels','on')
        self.y_ticklabels = kwargs.get('y_ticklabels','on')
        self.ax_accu = kwargs.get('ax_accu',"%g")
        self.symbol = kwargs.get('symbol','.-')
        self.colorbaron = kwargs.get('colorbaron','on')
        self.aspect = kwargs.get('aspect',None)
        self.ydir = kwargs.get('ydir','upright')
        self.xdir = kwargs.get('xdir','upright')
        self.margin = kwargs.get('margin',(0.,0.))
        self.origin = kwargs.get('origin',None)
        self.markersize = kwargs.get('markersize',None)
        self.no_frame = kwargs.get('no_frame','off')
        self.linestyle= kwargs.get('linestyle','-')
        self.frameon= kwargs.get('frameon',False)
        self.colo_place= kwargs.get('colo_place','bottom')
        self.colo_posi= kwargs.get('colo_posi','horizontal')
        # ......
        # color
        # ......
        self.midi = kwargs.get('midi',None)
        self.vmin = kwargs.get('vmin',None)
        self.vmax = kwargs.get('vmax',None)
        self.colo = kwargs.get('colo','ybwrk_colorblind')
        self.colop = kwargs.get('colop',None)
        self.scatter_colo = kwargs.get('scatter_colo',None)
        self.cololabel    = kwargs.get('cololabel',10)
        self.alpha = kwargs.get('alpha',None)
        # ......
        # save
        # ......
        self.guarda = kwargs.get('guarda','off')
        self.guarda_path = kwargs.get('guarda_path',"")
        self.transparent = kwargs.get('transparent','True')
        self.fig_name = kwargs.get('fig_name',None)
    def bring(path_,name_,mini,maxi,name__=None):
        import scipy.io as sio
        '''
        bring data from file
        file and variable have to be named the same!
        '''
        if name__==None:
            name__ = name_#+'.mat'
        file_  = path_ + name_ + '.mat'
        file_  = sio.loadmat(file_)
        file_  = file_[name__]
        file__ = file_[~np.isnan(file_)]
        mini_ = file__.min()
        maxi_ = file__.max()
        mini = min(mini,mini_)
        maxi = max(maxi,maxi_)
        return file_,mini,maxi
    def bring_struct(path_,name_,struct_,field_,mini,maxi):
        import scipy.io as sio
        '''
        bring data from file
        '''
        file_  = path_ + name_ + '.mat'
        file_  = sio.loadmat(file_)
        file_  = file_[struct_]
        # fields = file_.dtype
        field_ = field_.split('.')
        for i_ in range(len(field_)):
            file_ = file_[field_[i_]].item()
        file__ = file_[~np.isnan(file_)]
        mini_ = file__.min()
        maxi_ = file__.max()
        mini = min(mini,mini_)
        maxi = max(maxi,maxi_)
        return file_,mini,maxi
    def bring_cell(path_,name_):
        import scipy.io as sio
        '''
        bring data from file
        '''
        file_  = path_ + name_ + '.mat'
        file_  = sio.loadmat(file_)
        file_  = file_[name_]
        return file_
    # --------------------------------------------------------------------------
    #                               static methods
    # --------------------------------------------------------------------------
    @staticmethod
    def get_fig(self):
        if isinstance(self.plt_, types.ModuleType):
            plt = self.plt_
        else:
            import matplotlib.pyplot as plt
        fig=plt.gcf()
        if self.figsize is not None:
            fig.set_size_inches(self.figsize)
        return fig, plt
    @staticmethod
    def title_label(self,ax,fig):
        from matplotlib.ticker import FormatStrFormatter
        ax.yaxis.set_major_formatter(FormatStrFormatter(self.ax_accu)) # '%g'
        ax.xaxis.set_major_formatter(FormatStrFormatter(self.ax_accu)) #%g %.0f
        ax.set_title(self.title)
        ax.set_xlabel(self.xlabel)
        ax.set_ylabel(self.ylabel)
        if self.super_title is not None:
            fig.suptitle(self.super_title,fontweight='bold',fontsize=20,va='bottom')
    @staticmethod
    def cute_ticks(self,ax):
        if isinstance(self.yticks, list):
            ax.set_yticks(self.y)
            ax.set_yticklabels(self.yticks,fontsize='14')
        if isinstance(self.xticks, list):
            ax.set_xticks(self.x)
            ax.set_xticklabels(self.xticks,fontsize='14')
    @staticmethod
    def cute_axis(self,ax):
        if self.y_ticklabels=='off':
            ax.set_yticklabels([])
        if self.x_ticklabels=='off':
            ax.set_xticklabels([])
        if self.no_frame=='on':
            ax.set_axis_off()
    @staticmethod
    def disp_plt(self,plt):
        if self.super_title is not None:
            plt.tight_layout(rect=[0, 0.03, 1, 0.95]) # 0, 0.03, 1, 0.95
        else:
            if self.overlay=='false':
                plt.tight_layout()
        if self.holdon=='off':
            plt.show()
        elif self.holdon=='close':
            plt.close()
    @staticmethod
    def legenda(self,ax):
        if self.legends is not None:
            if isinstance(self.legend_coord,tuple):
                ax.legend(labels=self.legends,frameon=False,#
                bbox_to_anchor=self.legend_coord,#
                loc='center left',bbox_transform=ax.transData,borderaxespad=0.)
            else:
                ax.legend(labels=self.legends,frameon=self.frameon,facecolor='white')
    @staticmethod
    def save_me(self,fig):
        # .................
        # save figure
        # .................
        if type(self.guarda) is int:
            if self.fig_name is None:
                if self.title is None:
                    self.fig_name = "fig"
                else:
                    self.fig_name = self.title
            chars_bye = ['!', '?','/',')','(','.']
            cb = set(chars_bye)
            self.fig_name = ''.join([c for c in self.fig_name if c not in cb])
            fig_name = self.guarda_path + self.fig_name + ".png"
            fig_name = fig_name.replace(" ", "-")
            fig.savefig(fig_name, format='png', dpi=self.guarda,#
            bbox_inches='tight',
            transparent=self.transparent,pad_inches=0.05)
    # --------------------------------------------------------------------------
    def matrix(self):
        from mpl_toolkits.axes_grid1 import make_axes_locatable
        '''
        -----------------------------
        plot a matrix as imagesc
        -----------------------------
        simple example: 
            fancy_figure(data=data,
            x_ticklabels='off',y_ticklabels='off',
            midi=1,vmax=4,vmin=1,
            title=title,
            guarda=120).matrix()
        -----------------------------
        '''
        fig,plt = self.get_fig(self)
        # .................
        # build custom colormap
        # .................
        colo,norm = fancy_figure.colorea(self)
        # .................
        # build figure
        # .................
        plt.style.use('fancy_figure.mplstyle')
        if self.ax_ is None:
            ax = plt.gca()
        else:
            ax = self.ax_
        im = ax.imshow(self.data,cmap=colo,norm=norm,extent=self.extent,#
        aspect=self.aspect,origin=self.origin,alpha=self.alpha)
        # .................
        # title and labels
        # .................
        self.title_label(self,ax,fig)
        # .................
        # fancy ticks
        # .................
        self.cute_ticks(self,ax)
        # .................
        # fix colorbar position (so annoying)
        # .................
        if self.aspect is None:
            ax.axis('image')
        if self.colorbaron=='on':
            if self.xlabel == None:
                pad=0.2#0.2
            else:
                pad=0.6
            divider = make_axes_locatable(ax)
            cax = divider.append_axes(self.colo_place, size=0.15, pad=pad)
            cb=plt.colorbar(im, cax=cax,orientation=self.colo_posi,#
            format=self.colo_accu)
            cb.set_label(self.colo_title,fontsize=15)
        # .................
        # get fancy with axis
        # .................
        self.cute_axis(self,ax)
        # .................
        # display on screen
        # .................
        self.disp_plt(self,plt)
        # .................
        # save figure
        # .................
        self.save_me(self,fig)
        # .................
        # return built pic
        # .................
        return plt
    # --------------------------------------------------------------------------
    def pmatrix(self):
        from mpl_toolkits.axes_grid1 import make_axes_locatable
        '''
        plot a matrix as pcolor
        '''
        fig,plt = self.get_fig(self)
        # .................
        # build custom colormap
        # .................
        colo,norm = fancy_figure.colorea(self)
        # .................
        # build figure
        # .................
        plt.style.use('fancy_figure.mplstyle')
        if self.ax_ is None:
            ax = plt.gca()
        else:
            ax = self.ax_
        if (self.y is not None and self.x is not None):
            y = self.y
            x = self.x
        else:
            y = np.arange(self.data.shape[0])
            x = np.arange(self.data.shape[1])
        im=ax.pcolor(x,y,self.data,cmap=colo,norm=norm)
        ax.invert_yaxis()
        # .................
        # title and labels
        # .................
        self.title_label(self,ax,fig)
        # .................
        # fancy ticks
        # .................
        self.cute_ticks(self,ax)
        # .................
        # fix colorbar position (so annoying)
        # .................
        if self.aspect is None:
            ax.axis('image')
        if self.colorbaron=='on':
            if self.xlabel == None:
                pad=0.2
            else:
                pad=0.6
            divider = make_axes_locatable(ax)
            cax = divider.append_axes('bottom', size=0.15, pad=pad)
            cb=plt.colorbar(im, cax=cax,orientation='horizontal',#
            format=self.colo_accu)
            cb.set_label(self.colo_title,fontsize=10)
        # .................
        # get fancy with axis
        # .................
        self.cute_axis(self,ax)
        # .................
        # display on screen
        # .................
        self.disp_plt(self,plt)
        # .................
        # save figure
        # .................
        self.save_me(self,fig)
        # .................
        # return built pic
        # .................
        return plt
    # --------------------------------------------------------------------------
    def plotter(self):
        '''
        -----------------------------
        plot a curve in 2d
        -----------------------------
        simple example:
            fancy_figure(curve=y,x=x
            xlabel='x value',ylabel='y depends on x',
            title='Some title',
            colop=((0.2,0.1,0.3)),margin=(0.02,0.03),
            guarda_path='pics/',
            guarda=120).plotter()
        -----------------------------
        '''
        fig,plt = self.get_fig(self)
        # .................
        # build figure
        # .................
        plt.style.use('fancy_figure.mplstyle')
        if self.ax_ is None:
            ax = plt.gca()
        else:
            ax = self.ax_
        if self.x is None:
            self.x = np.arange(1.,self.curve.size+1)
        ax.plot(self.x,self.curve,self.symbol, color=self.colop,markersize=self.markersize)
        if self.xdir == 'reverse':
            ax.invert_xaxis()
        if self.ydir == 'reverse':
            ax.invert_yaxis()
        if self.xlim is not None:
            ax.set_xlim(self.xlim[0],self.xlim[1])
        if self.ylim is not None:
            ax.set_ylim(self.ylim[0],self.ylim[1])
        if self.aspect is not None:
            ax.set_aspect(aspect=self.aspect) 
        ax.margins(self.margin[0],self.margin[1])
        # .................
        # color lines from colormap
        # .................
        # colors = plt.cm.jet(np.linspace(0,1,20))
        # ax.plot(self.x,self.curve,self.symbol, color=colors)
        # .................
        # title and labels
        # .................
        self.title_label(self,ax,fig)
        # .................
        # legends
        # .................
        self.legenda(self,ax)
        # .................
        # fancy ticks
        # .................
        self.cute_ticks(self,ax)
        # .................
        # get fancy with axis
        # .................
        self.cute_axis(self,ax)
        # .................
        # display on screen
        # .................
        self.disp_plt(self,plt)
        # .................
        # save figure
        # .................
        self.save_me(self,fig)
        # .................
        # return built pic
        # .................
        return plt
    # --------------------------------------------------------------------------
    # --------------------------------------------------------------------------
    def scatterer(self):
        from mpl_toolkits.axes_grid1 import make_axes_locatable
        '''
        -----------------------------
        plot a scatterer
        -----------------------------
        simple example:
            -_-
        -----------------------------
        '''
        fig,plt = self.get_fig(self)
        # .................
        # build figure
        # .................
        plt.style.use('fancy_figure.mplstyle')
        if self.ax_ is None:
            ax = plt.gca()
        else:
            ax = self.ax_
        if self.x is None:
            self.x = np.arange(1.,self.curve.size+1)
        # .................
        # build custom colormap
        # .................
        if self.vmin is None:
            self.vmin = self.scatter_colo.min()
        if self.vmax is None:
            self.vmax = self.scatter_colo.max()
        if self.midi is None:
            self.midi = 0.5*(self.vmin + self.vmax)
        colo,norm = fancy_figure.colorea(self)
        # .................
        # scatter
        # .................
        im=ax.scatter(self.x,self.curve,marker=self.symbol,c=self.scatter_colo,
        cmap=colo,norm=norm,edgecolor='k')
        if self.xdir == 'reverse':
            ax.invert_xaxis()
        if self.ydir == 'reverse':
            ax.invert_yaxis()
        ax.margins(self.margin[0],self.margin[1]) 
        # .................
        # fix colorbar position (so annoying)
        # .................
        if self.colorbaron=='on':
            pad=0.2
            divider = make_axes_locatable(ax)
            cax = divider.append_axes('right', size=0.15, pad=pad)
            cb=plt.colorbar(im, cax=cax,orientation='vertical',#
            format=self.colo_accu)
            cb.set_label(self.colo_title,fontsize=13)
        # .................
        # color lines from colormap
        # .................
        # colors = plt.cm.jet(np.linspace(0,1,20))
        # ax.plot(self.x,self.curve,self.symbol, color=colors)
        # .................
        # title and labels
        # .................
        self.title_label(self,ax,fig)
        # .................
        # legends
        # .................
        self.legenda(self,ax)
        # .................
        # fancy ticks
        # .................
        self.cute_ticks(self,ax)
        # .................
        # get fancy with axis
        # .................
        self.cute_axis(self,ax)
        # .................
        # display on screen
        # .................
        self.disp_plt(self,plt)
        # .................
        # save figure
        # .................
        self.save_me(self,fig)
        # .................
        # return built pic
        # .................
        return plt
    # --------------------------------------------------------------------------
    def polar(self):
        import numpy as np
        from mpl_toolkits.axes_grid1 import make_axes_locatable
        '''
        plot a polar
        '''
        if isinstance(self.plt_, types.ModuleType):
          plt = self.plt_
          fig,ax=plt.subplots(subplot_kw=dict(projection='polar'))
        else:
          import matplotlib.pyplot as plt
          fig,ax=plt.subplots(subplot_kw=dict(projection='polar'))
        if self.figsize is not None:
          fig.set_size_inches(self.figsize)
        # .................
        # build custom colormap
        # .................
        colo,norm = fancy_figure.colorea(self)
        # .................
        # build figure
        # .................
        plt.style.use('fancy_figure.mplstyle')
        v, theta = np.meshgrid(self.v, self.theta)
        # x = np.multiply(v , np.cos(theta))
        # y = np.multiply(v , np.sin(theta))
        # im = ax.contourf(x, y, self.data,cmap=colo,norm=norm)
        im = ax.contourf(theta, v, self.data,cmap=colo,norm=norm,levels=200)
        ax.set_ylim(0,v.max()) 
        # .................
        # title and labels
        # .................
        from matplotlib.ticker import FormatStrFormatter
        ax.yaxis.set_major_formatter(FormatStrFormatter(self.ax_accu)) # '%g'
        ax.xaxis.set_major_formatter(FormatStrFormatter(self.ax_accu)) #%g %.0f
        plt.title(self.title)
        if self.ylabel is not None:
            label_position=ax.get_rlabel_position()
            ax.text(np.radians(label_position),ax.get_rmax()*1.05,self.ylabel,
            ha='left',va='bottom',fontsize=15)
            ax.tick_params(colors='c')
        if isinstance(self.yticks, list):
            ax.set_yticks(self.y)
            ax.set_yticklabels(self.yticks,fontsize='15')
        if isinstance(self.xticks, list):
            ax.set_xticks(self.x)
            ax.set_xticklabels(self.xticks,fontsize='10')
        # .................
        # fancy ticks
        # .................
        self.cute_axis(self,ax)
        ax.grid(False)
        # .................
        # get fancy with axis
        # .................
        
        # .................
        # display on screen
        # .................
        self.disp_plt(self,plt)
        # .................
        # save figure
        # .................
        self.save_me(self,fig)
        # .................
        # return built pic
        # .................
        return plt
    # --------------------------------------------------------------------------
    def cleaner(self):
        '''
        clean a plot
        '''
        plt=self.plt_
        fig=plt.gcf()
        ax =plt.gca()
        # .................
        # margins
        # .................
        ax.margins(self.margin[0],self.margin[1]) 
        # .................
        # title and labels
        # .................
        self.title_label(self,ax,fig)
        # .................
        # legends
        # .................
        self.legenda(self,ax)
        # .................
        # fancy ticks
        # .................
        self.cute_ticks(self,ax)
        # .................
        # get fancy with axis
        # .................
        self.cute_axis(self,ax)
        # .................
        # display on screen
        # .................
        self.disp_plt(self,plt)
        # .................
        # save figure
        # .................
        self.save_me(self,fig)
        # .................
        # return built pic
        # .................
        return plt
    # --------------------------------------------------------------------------
    def colorbar_alone(self):
        '''
        do a colorbar by itself
        '''
        import matplotlib as mpl
        if isinstance(self.plt_, types.ModuleType):
            plt = self.plt_
        else:
            import matplotlib.pyplot as plt
        # -------------------
        # 
        # -------------------
        fig = plt.figure(figsize=self.figsize)
        # [left, bottom, width, height] of the new axes. 
        # All quantities are in fractions of figure width and height.
        h = 0.15 / self.figsize[1]
        ax = fig.add_axes([0.05, 0.8, 0.65, h])
        # -------------------
        # 
        # -------------------
        colo,norm = fancy_figure.colorea(self)
        cb = mpl.colorbar.ColorbarBase(ax, cmap=colo,norm=norm,#
        orientation='horizontal',format=self.colo_accu)
        cb.set_label(self.colo_title,fontsize=15) # 15
        cb.ax.tick_params(labelsize=self.cololabel) # 10
        # .................
        # display on screen
        # .................
        if self.holdon=='off':
            plt.show()
        # .................
        # save figure
        # .................
        self.save_me(self,fig)
        # .................
        # return built pic
        # .................
        return plt
    # --------------------------------------------------------------------------
    def colorea(self):
        '''
        do a cool colormap
        '''
        import numpy as np
        if self.colo == 'br':
            from matplotlib import cm
            from matplotlib.colors import ListedColormap
            colo   = cm.get_cmap('Blues_r', 128)
            colo_  = cm.get_cmap('Reds', 128)
            # colo   = cm.get_cmap('YlOrRd_r', 128)
            # colo_  = cm.get_cmap('PuBuGn', 128)
            colo   = np.vstack((colo(np.linspace(0, 1, 128)),
                                   colo_(np.linspace(0, 1, 128))))
            colo = ListedColormap(colo)
        # -------------------------
        if self.colo == 'kkrr':
            from matplotlib import cm
            from matplotlib.colors import ListedColormap
            colo   = cm.get_cmap('Greys_r', 128)
            colo_  = cm.get_cmap('Reds', 128)
            colo   = np.vstack((colo(np.linspace(0, 1, 128)),
                                   colo_(np.linspace(0, 1, 128))))
            colo = ListedColormap(colo)
        # -------------------------
        if self.colo == 'Greys':
            colo='Greys'
        # -------------------------
        if self.colo == 'hot':
            colo='hot_r'
        # -------------------------
        if self.colo == 'coolwarm':
            colo='coolwarm'
        # -------------------------
        if self.colo == 'Blues':
            colo='Blues'
        # -------------------------
        if self.colo == 'plasma':
            colo='plasma'
        # -------------------------
        if self.colo == 'viridis':
            colo='viridis'
        # -------------------------
        if self.colo == 'RdGy':
            colo='RdGy'
        # -------------------------
        if self.colo == 'cool':
            colo='cool'
        # -------------------------
        if self.colo == 'b-gb':
            from matplotlib.colors import LinearSegmentedColormap
            colo  = [(0,0,0),(0,1,1)]
            colo  = LinearSegmentedColormap.from_list('name',colors=colo,N=256)
        # -------------------------
        if self.colo == 'r-rgb':
            from matplotlib.colors import LinearSegmentedColormap
            colo  = [(0.5,0,0),(0.5,1,1)]
            colo  = LinearSegmentedColormap.from_list('name',colors=colo,N=256)
        # -------------------------
        if self.colo == 'rb-rg':
            from matplotlib.colors import LinearSegmentedColormap
            colo  = [(1,0,1),(1,1,0)]
            colo  = LinearSegmentedColormap.from_list('name',colors=colo,N=256)
        # -------------------------
        if self.colo == 'b-gb':
            from matplotlib.colors import LinearSegmentedColormap
            colo  = [(0,0,0),(0,1,1)]
            colo  = LinearSegmentedColormap.from_list('name',colors=colo,N=256)
        # -------------------------
        if self.colo == 'r-rg':
            from matplotlib.colors import LinearSegmentedColormap
            colo  = [(1,0,0),(1,1,0)]
            colo  = LinearSegmentedColormap.from_list('name',colors=colo,N=256)
        # -------------------------
        if self.colo == 'kgr':
            from matplotlib.colors import LinearSegmentedColormap
            colo  = [(0,0,0),(0,1,0),(1,0,0)]
            colo  = LinearSegmentedColormap.from_list('name',colors=colo,N=256)
        # -------------------------
        if self.colo == 'kr':
            from matplotlib.colors import LinearSegmentedColormap
            colo  = [(0,0,0),(1,0,0)]
            colo  = LinearSegmentedColormap.from_list('name',colors=colo,N=256)
        # -------------------------
        if self.colo == 'kb':
            from matplotlib.colors import LinearSegmentedColormap
            colo  = [(0,0,0),(0,0,1)]
            colo  = LinearSegmentedColormap.from_list('name',colors=colo,N=256)
        # -------------------------
        if self.colo == 'kg':
            from matplotlib.colors import LinearSegmentedColormap
            colo  = [(0,0,0),(0,1,0)]
            colo  = LinearSegmentedColormap.from_list('name',colors=colo,N=256)
        # -------------------------
        if self.colo == 'cafe':
            from matplotlib.colors import LinearSegmentedColormap
            colo  = [(1,1,1),(0.5098,0.2667,0.0902)]
            colo  = LinearSegmentedColormap.from_list('name',colors=colo,N=256)
        # -------------------------
        if self.colo == 'y-b':
            from matplotlib.colors import LinearSegmentedColormap
            # colo  = [(0.8275,0.7922,0.0745),(0.865,0.865,0.865),(0.1176,0.2980,0.5882)]
            colo  = [(0.8275,0.7922,0.0745),(0.865,0.865,0.865),(0.1549,0.5471,0.7372)]
            colo  = LinearSegmentedColormap.from_list('name',colors=colo,N=256)
        # -------------------------
        if self.colo == 'johns':
            # john's favorite velocity colormap
            from matplotlib.colors import LinearSegmentedColormap
            colo  = [(0,0,0.9608),(0.2353,1,0),(0.8824,0,0)]
            colo  = LinearSegmentedColormap.from_list('name',colors=colo,N=256)
        # -------------------------
        if self.colo == 'groundwater':
            from matplotlib.colors import LinearSegmentedColormap
            colo  = [(0.8275,0.7922,0.0745),(0.4 ,0.2 ,0)]
            # colo_ = [(0.865,0.865,0.865), (0.2039,0.4824,0.8980),(0.0353,0.2784,0.6392)]
            colo_ = [(0.865,0.865,0.865), (0.2039,0.4824,0.8980),(0.3765,0.0353,0.6196)]
            colo = colo + colo_
            colo  = LinearSegmentedColormap.from_list('name',colors=colo,N=256)
        # -------------------------
        if self.colo == 'groundwater_colorblind':
            from matplotlib.colors import LinearSegmentedColormap
            colo  = [(1.0000,0.7608,0.0392),(0.6000,0.3098,0)]
            colo_ = [(0.865,0.865,0.865), (0.0471,0.4824,0.8627),(0.3647,0.2275,0.6078)]
            colo = colo + colo_
            colo  = LinearSegmentedColormap.from_list('name',colors=colo,N=256)
        # -------------------------
        if self.colo == 'groundwater_':
            from matplotlib.colors import LinearSegmentedColormap
            # colo  = [(0.3765,0.0353,0.6196),(0.2039,0.4824,0.8980)]
            colo  = [(0.3765,0.0353,0.6196),(0.0275,0.7647,0.9882)]
            colo_ = [(0.865,0.865,0.865),(0.4 ,0.2 ,0),(0.8275,0.7922,0.0745)]
            colo = colo + colo_
            colo  = LinearSegmentedColormap.from_list('name',colors=colo,N=256)
        # -------------------------
        if self.colo == 'glacier':
            from matplotlib.colors import LinearSegmentedColormap
            colo  = [(0.9,0.9,0.9),(0,0,0)]
            colo_ = [(0.9294,0.9137,0.0627),(0.0627,0.3216,0.9294)]
            colo = colo + colo_
            colo  = LinearSegmentedColormap.from_list('name',colors=colo,N=256)
        # -------------------------
        if self.colo == 'crazy_mellow':
            from matplotlib.colors import LinearSegmentedColormap
            colo  = [(0.3765,0.0353,0.6196),(0.8980,0.3059,0.0706)]
            colo_ = [(0.865,0.865,0.865),(0.2510,0.5490,0.2549),(0.8275,0.7922,0.0745)]
            colo = colo + colo_
            colo  = LinearSegmentedColormap.from_list('name',colors=colo,N=256)
        # -------------------------
        if self.colo == 'crazy_light':
            from matplotlib.colors import LinearSegmentedColormap
            colo  = [(0.0353,0.8824,0.9569),(0.4824,0.1961,0.6588)]
            colo_ = [(0.865,0.865,0.865), (0.9882,0.6000,0.0196),(0.0353,0.9569,0.2353)]
            # colo_ = [(0.865,0.865,0.865), (0.9569,0.9882,0.0196),(0.0353,0.9569,0.2353)]
            colo = colo + colo_
            colo  = LinearSegmentedColormap.from_list('name',colors=colo,N=256)
        # -------------------------
        if self.colo == 'apbcv':
            from matplotlib.colors import LinearSegmentedColormap
            colo  = [(0.8275,0.7922,0.0745),(0.4824,0.1961,0.6588)]
            colo_ = [(0.865,0.865,0.865), (0.4 ,0.2 ,0),(0.2,0.6,0.2)]
            # colo_ = [(0.9765,0.2510,0.9294),(0.8078, 0.0941,0.0941),(0,0,0)]
            colo = colo + colo_
            colo  = LinearSegmentedColormap.from_list('name',colors=colo,N=256)
        # -------------------------
        if self.colo == 'ybwrk':
            from matplotlib.colors import LinearSegmentedColormap
            colo  = [(0.8275,0.7922,0.0745),(0.230,0.299,0.754)]
            colo_ = [(0.865,0.865,0.865), (0.8078, 0.0941,0.0941),(0,0,0)]
            # colo_ = [(0.9765,0.2510,0.9294),(0.8078, 0.0941,0.0941),(0,0,0)]
            colo = colo + colo_
            colo  = LinearSegmentedColormap.from_list('name',colors=colo,N=256)
        # -------------------------
        if self.colo == 'ybwrk_colorblind':
            from matplotlib.colors import LinearSegmentedColormap
            colo  = [(0.9412,0.8941,0.2588),(0.0471,0.4824,0.8627)]
            colo_ = [(0.865,0.865,0.865), (0.8627,0.1961,0.1255),(0,0,0)]
            colo = colo + colo_
            colo  = LinearSegmentedColormap.from_list('name',colors=colo,N=256)
        # -------------------------
        if self.vmin is None:
            # self.vmin = self.data.min()
            self.vmin = np.nanmin(self.data)
        if self.vmax is None:
            # self.vmax = self.data.max()
            self.vmax = np.nanmax(self.data)
        if self.midi is None:
            self.midi = 0.5*(self.vmin + self.vmax)  
        norm = MidpointNormalize(midpoint=self.midi,vmin=self.vmin,vmax=self.vmax)
        # -------------------------
        return colo, norm
# ------------------------------------------------------------------------------
import matplotlib.colors as colors
import numpy as np
class MidpointNormalize(colors.Normalize):
    def __init__(self, vmin=None, vmax=None, midpoint=None, clip=False):
        self.midpoint = midpoint
        colors.Normalize.__init__(self, vmin, vmax, clip)
    def __call__(self, value, clip=None):
        x, y = [self.vmin, self.midpoint, self.vmax], [0, 0.5, 1]
        return np.ma.masked_array(np.interp(value, x, y))
        