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
        if self.xdir == 'reverse':
            ax.invert_xaxis()
        if self.ydir == 'reverse':
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
    def semilogx(self):
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
            guarda=120).semilogx()
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
        ax.semilogx(self.x,self.curve,self.symbol, color=self.colop,markersize=self.markersize)
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
            from matplotlib import cm
            from matplotlib.colors import ListedColormap
            colo = cm.get_cmap('Greys', 256)
            colo = colo(np.linspace(0, 1, 256))
            colo = ListedColormap(colo)
        # -------------------------
        if self.colo == 'hot':
            from matplotlib import cm
            from matplotlib.colors import ListedColormap
            colo = cm.get_cmap('hot_r', 256)
            colo = colo(np.linspace(0, 1, 256))
            colo = ListedColormap(colo)
        # -------------------------
        if self.colo == 'OrRd':
            from matplotlib import cm
            from matplotlib.colors import ListedColormap
            colo = cm.get_cmap('OrRd', 256)
            colo = colo(np.linspace(0, 1, 256))
            colo = ListedColormap(colo)
        # -------------------------
        if self.colo == 'coolwarm':
            from matplotlib import cm
            from matplotlib.colors import ListedColormap
            colo = cm.get_cmap('coolwarm', 256)
            colo = colo(np.linspace(0, 1, 256))
            colo = ListedColormap(colo)
        # -------------------------
        if self.colo == 'Blues':
            colo='Blues'
        # -------------------------
        if self.colo == 'plasma':
            from matplotlib import cm
            from matplotlib.colors import ListedColormap
            colo = cm.get_cmap('plasma', 256)
            colo = colo(np.linspace(0, 1, 256))
            colo = ListedColormap(colo)
        # -------------------------
        if self.colo == 'inferno':
            from matplotlib import cm
            from matplotlib.colors import ListedColormap
            colo = cm.get_cmap('inferno', 256)
            colo = colo(np.linspace(0, 1, 256))
            colo = ListedColormap(colo)
        # -------------------------
        if self.colo == 'magma':
            from matplotlib import cm
            from matplotlib.colors import ListedColormap
            colo = cm.get_cmap('magma', 256)
            colo = colo(np.linspace(0, 1, 256))
            colo = ListedColormap(colo)
        # -------------------------
        if self.colo == 'viridis':
            from matplotlib import cm
            from matplotlib.colors import ListedColormap
            colo = cm.get_cmap('viridis', 256)
            colo = colo(np.linspace(0, 1, 256))
            colo = ListedColormap(colo)
        # -------------------------
        if self.colo == 'RdGy':
            from matplotlib import cm
            from matplotlib.colors import ListedColormap
            colo = cm.get_cmap('RdGy', 256)
            colo = colo(np.linspace(0, 1, 256))
            colo = ListedColormap(colo)
        # -------------------------
        if self.colo == 'cool':
            from matplotlib import cm
            from matplotlib.colors import ListedColormap
            colo = cm.get_cmap('cool', 256)
            colo = colo(np.linspace(0, 1, 256))
            colo = ListedColormap(colo)
        # -------------------------
        if self.colo == 'turbo':
            from matplotlib import cm
            from matplotlib.colors import ListedColormap
            colo = cm.get_cmap('turbo', 256)
            colo = colo(np.linspace(0, 1, 256))
            colo = ListedColormap(colo)
        # -------------------------
        if self.colo == 'gnuplot':
            from matplotlib import cm
            from matplotlib.colors import ListedColormap
            colo = cm.get_cmap('gnuplot', 256)
            colo = colo(np.linspace(0, 1, 256))
            colo = ListedColormap(colo)
        # -------------------------
        if self.colo == 'plasma':
            from matplotlib import cm
            from matplotlib.colors import ListedColormap
            colo = cm.get_cmap('plasma', 256)
            colo = colo(np.linspace(0, 1, 256))
            colo = ListedColormap(colo)
        # -------------------------
        if self.colo == 'Dark2':
            from matplotlib import cm
            from matplotlib.colors import ListedColormap
            colo = cm.get_cmap('Dark2', 256)
            colo = colo(np.linspace(0, 1, 256))
            colo = ListedColormap(colo)
        # -------------------------
        if self.colo == 'tab20c':
            from matplotlib import cm
            from matplotlib.colors import ListedColormap
            colo = cm.get_cmap('tab20c', 256)
            colo = colo(np.linspace(0, 1, 256))
            colo = ListedColormap(colo)
        # -------------------------
        if self.colo == 'flag':
            from matplotlib import cm
            from matplotlib.colors import ListedColormap
            colo = cm.get_cmap('flag', 256)
            colo = colo(np.linspace(0, 1, 256))
            colo = ListedColormap(colo)
        # -------------------------
        if self.colo == 'brg':
            from matplotlib import cm
            from matplotlib.colors import ListedColormap
            colo = cm.get_cmap('brg', 256)
            colo = colo(np.linspace(0, 1, 256))
            colo = ListedColormap(colo)
        # -------------------------
        if self.colo == 'gist_ncar':
            from matplotlib import cm
            from matplotlib.colors import ListedColormap
            colo = cm.get_cmap('gist_ncar', 256)
            colo = colo(np.linspace(0, 1, 256))
            colo = ListedColormap(colo)
        # -------------------------
        if self.colo == 'prism':
            from matplotlib import cm
            from matplotlib.colors import ListedColormap
            colo = cm.get_cmap('prism', 256)
            colo = colo(np.linspace(0, 1, 256))
            colo = ListedColormap(colo)
        # -------------------------
        if self.colo == 'nipy_spectral':
            from matplotlib import cm
            from matplotlib.colors import ListedColormap
            colo = cm.get_cmap('nipy_spectral', 256)
            colo = colo(np.linspace(0, 1, 256))
            colo = ListedColormap(colo)
        # -------------------------
        if self.colo == 'Spectral':
            from matplotlib import cm
            from matplotlib.colors import ListedColormap
            colo = cm.get_cmap('Spectral', 256)
            colo = colo(np.linspace(0, 1, 256))
            colo = ListedColormap(colo)
        # -------------------------
        if self.colo == 'PuOr':
            from matplotlib import cm
            from matplotlib.colors import ListedColormap
            colo = cm.get_cmap('PuOr', 256)
            colo = colo(np.linspace(0, 1, 256))
            colo = ListedColormap(colo)
        # -------------------------
        if self.colo == 'PRGn':
            from matplotlib import cm
            from matplotlib.colors import ListedColormap
            colo = cm.get_cmap('PRGn', 256)
            colo = colo(np.linspace(0, 1, 256))
            colo = ListedColormap(colo)
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
        if self.colo == 'contaminant':
            from matplotlib.colors import LinearSegmentedColormap
            colo  = [(0,0,0),(0.1686,0.1412,0.9490)]
            colo_ = [(0.865,0.865,0.865), (0.8471,0.2588,0.8667),(0.2784,0.8667,0.2588)]
            colo = colo + colo_
            colo  = LinearSegmentedColormap.from_list('name',colors=colo,N=256)
        # -------------------------
        if self.colo == 'tabber':
            from matplotlib.colors import LinearSegmentedColormap
            colo_ = [(0.2902,0.4588,0.8863),(0.6824,0.7569,0.9490)]
            colo__= [(0.8980,0.2824,0.0784), (0.9490,0.7059,0.6235)]
            colo  = colo_ + colo__
            colo_ = [(0.2902,0.7176,0.1843),(0.5961,0.8863,0.5216)]
            colo__= [(0.5569,0.1569,0.7294), (0.7686,0.5176,0.8784)]
            colo  = colo + colo_ + colo__
            colo_ = [(0.466,0.466,0.466),(0.7373,0.7373,0.7373)]
            colo  = colo + colo_
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
            colo_ = [(0.865,0.865,0.865), (0.2039,0.4824,0.8980),(0.3765,0.0353,0.6196)]
            colo = colo + colo_
            colo  = LinearSegmentedColormap.from_list('name',colors=colo,N=256)
        # -------------------------
        if self.colo == 'groundwater_colorblind':
            from matplotlib.colors import LinearSegmentedColormap
            colo  = [(1.0,0.7608,0.0392),(0.6,0.3098,0)]
            colo_ = [(0.865,0.865,0.865), (0.0471,0.4824,0.8627),(0.3647,0.2275,0.6078)]
            colo = colo + colo_
            colo  = LinearSegmentedColormap.from_list('name',colors=colo,N=256)
        # -------------------------
        if self.colo == 'groundwater_colorblind_':
            from matplotlib.colors import LinearSegmentedColormap
            colo  = [(0.3647,0.2275,0.6078),(0.0471,0.4824,0.8627)]
            colo_ = [(0.865,0.865,0.865),(0.6,0.3098,0), (1.0,0.7608,0.0392)]
            colo = colo + colo_
            colo  = LinearSegmentedColormap.from_list('name',colors=colo,N=256)
        # -------------------------
        if self.colo == 'groundwater_':
            from matplotlib.colors import LinearSegmentedColormap
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
        if self.colo == 'glacier_':
            from matplotlib.colors import LinearSegmentedColormap
            colo  = [(0.0627,0.3216,0.9294),(0.9294,0.9137,0.0627)]
            colo_ = [(0,0,0),(0.9,0.9,0.9)]
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
            colo_ = [(0.865,0.865,0.865), (0.9882,0.6,0.0196),(0.0353,0.9569,0.2353)]
            colo = colo + colo_
            colo  = LinearSegmentedColormap.from_list('name',colors=colo,N=256)
        # -------------------------
        if self.colo == 'cytwombly':
            from matplotlib.colors import LinearSegmentedColormap
            colo  = [(0.9569,0.4,0.0275),(0.9490,0.8941,0.1412)]
            colo_ = [(0.865,0.865,0.865), (0.0275,0.7725,0.9569),(0.0157,0.1294,0.6392)]
            colo = colo + colo_
            colo  = LinearSegmentedColormap.from_list('name',colors=colo,N=256)
        # -------------------------
        if self.colo == 'cytwombly_':
            from matplotlib.colors import LinearSegmentedColormap
            colo  = [(0.0157,0.1294,0.6392),(0.0275,0.7725,0.9569)]
            colo_ = [(0.865,0.865,0.865),(0.9490,0.8941,0.1412),(0.9569,0.4,0.0275)]
            colo = colo + colo_
            colo  = LinearSegmentedColormap.from_list('name',colors=colo,N=256)
        # -------------------------
        if self.colo == 'spacedust':
            from matplotlib.colors import LinearSegmentedColormap
            colo  = [(0.0275,0.7725,0.9569),(0.0157,0.1294,0.6392)]
            colo_ = [(0,0,0),(0.9569,0.4,0.0275),(0.9490,0.8941,0.1412)]
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
        if self.colo == 'tepoz':
            from matplotlib.colors import LinearSegmentedColormap
            # tierra hojas cielo rojo piedra
            colo  = [(0.6078,0.4627,0.0941),(0.3294,0.5490,0.1725)]
            colo_ = [(0.1098,0.6902,0.9373), (0.9686,0.1137,0.2157),(0.5373,0.3333,0.3020)]
            colo = colo + colo_
            colo  = LinearSegmentedColormap.from_list('name',colors=colo,N=256)
        # -------------------------
        if self.colo == 'painbow':
            from matplotlib.colors import LinearSegmentedColormap
            colo  = [(1e+00,1e+00,1e+00),(9.9607843e-01,9.9607843e-01,1e+00),(9.8039216e-01,9.8039216e-01,9.8823529e-01),(9.5686275e-01,9.5686275e-01,9.6862745e-01),(9.2156863e-01,9.2549020e-01,9.4509804e-01),(8.9411765e-01,8.9411765e-01,9.2549020e-01),(8.5882353e-01,8.5490196e-01,9.0196078e-01),(8.1960784e-01,8.1960784e-01,8.7058824e-01),(7.8039216e-01,7.8039216e-01,8.3529412e-01),(7.3333333e-01,7.4117647e-01,7.9607843e-01),(6.8627451e-01,7.0196078e-01,7.6470588e-01),(6.4313725e-01,6.5490196e-01,7.2941176e-01),(6e-01,6.1176471e-01,6.9019608e-01),(5.6078431e-01,5.6862745e-01,6.5098039e-01),(5.2941176e-01,5.3725490e-01,6.1568627e-01),(4.9411765e-01,5.0588235e-01,5.7647059e-01),(4.5490196e-01,4.6666667e-01,5.3333333e-01),(4.1568627e-01,4.2745098e-01,4.8627451e-01),(3.8431373e-01,3.8039216e-01,4.3921569e-01),(3.4117647e-01,3.4117647e-01,3.9607843e-01),(2.9803922e-01,2.9803922e-01,3.4117647e-01),(2.5490196e-01,2.5882353e-01,2.9411765e-01),(2.1568627e-01,2.1568627e-01,2.4313725e-01),(1.7647059e-01,1.7254902e-01,1.9607843e-01),(1.4117647e-01,1.3725490e-01,1.5686275e-01),(1.0588235e-01,1.0196078e-01,1.1764706e-01),(7.4509804e-02,7.4509804e-02,7.4509804e-02),(4.7058824e-02,4.7058824e-02,3.9215686e-02),(2.3529412e-02,2.3529412e-02,2.3529412e-02),(3.9215686e-03,3.9215686e-03,7.8431373e-03),(0,0,0),(0,0,1.1764706e-02),(0,0,4.7058824e-02),(0,7.8431373e-03,9.8039216e-02),(1.1764706e-02,3.5294118e-02,1.6470588e-01),(3.5294118e-02,7.0588235e-02,2.2352941e-01),(6.6666667e-02,1.0588235e-01,2.8627451e-01),(8.6274510e-02,1.2941176e-01,3.1372549e-01),(1.0980392e-01,1.5294118e-01,3.3725490e-01),(1.3333333e-01,1.7647059e-01,3.6078431e-01),(1.6470588e-01,2.0392157e-01,3.8823529e-01),(2e-01,2.3137255e-01,4.1568627e-01),(2.2745098e-01,2.6274510e-01,4.3921569e-01),(2.5882353e-01,2.9411765e-01,4.6666667e-01),(2.9019608e-01,3.2156863e-01,4.9019608e-01),(3.1764706e-01,3.5294118e-01,5.0980392e-01),(3.4117647e-01,3.7647059e-01,5.2156863e-01),(3.6470588e-01,4e-01,5.3725490e-01),(3.7647059e-01,4.2352941e-01,5.4509804e-01),(3.7647059e-01,4.4313725e-01,5.4901961e-01),(3.7254902e-01,4.5882353e-01,5.4117647e-01),(3.4117647e-01,4.7450980e-01,5.2156863e-01),(2.9019608e-01,4.9411765e-01,5.0196078e-01),(2.5098039e-01,4.9019608e-01,4.8235294e-01),(2.1176471e-01,4.8627451e-01,4.4705882e-01),(1.5686275e-01,4.8627451e-01,4.1176471e-01),(1.0980392e-01,4.8627451e-01,3.7647059e-01),(7.8431373e-02,4.8627451e-01,3.4509804e-01),(4.7058824e-02,4.9019608e-01,3.1372549e-01),(1.1764706e-02,4.9019608e-01,2.7843137e-01),(1.1764706e-01,4.7450980e-01,2.5490196e-01),(1.4117647e-01,4.4313725e-01,2.2352941e-01),(2.0784314e-01,4e-01,1.9607843e-01),(3.2941176e-01,3.3725490e-01,1.6862745e-01),(4.4313725e-01,2.7058824e-01,1.4117647e-01),(5.5294118e-01,2.1176471e-01,1.1372549e-01),(6.7843137e-01,1.4509804e-01,8.6274510e-02),(7.8823529e-01,8.6274510e-02,6.2745098e-02),(8.7450980e-01,5.8823529e-02,4.7058824e-02),(9.4901961e-01,2.3529412e-02,1.9607843e-02),(9.9215686e-01,0,1.5686275e-02),(9.9607843e-01,1.1764706e-02,7.8431373e-03),(9.9215686e-01,1.5686275e-02,0),(9.9215686e-01,7.8431373e-03,0),(9.8823529e-01,1.5686275e-02,3.9215686e-03),(9.8823529e-01,7.8431373e-03,7.8431373e-03),(9.8039216e-01,1.5686275e-02,3.9215686e-03),(9.7254902e-01,2.3529412e-02,3.9215686e-03),(9.7254902e-01,1.5686275e-02,0),(9.6078431e-01,3.1372549e-02,0),(9.5294118e-01,4.3137255e-02,3.9215686e-03),(9.4509804e-01,3.9215686e-02,3.9215686e-03),(9.2941176e-01,5.8823529e-02,0),(9.1372549e-01,6.6666667e-02,3.9215686e-03),(9.0588235e-01,7.4509804e-02,7.8431373e-03),(8.9019608e-01,7.8431373e-02,3.9215686e-03),(8.7843137e-01,7.8431373e-02,0),(8.6274510e-01,9.8039216e-02,0),(8.5098039e-01,1.1372549e-01,0),(8.3137255e-01,1.1764706e-01,0),(8.1960784e-01,1.2549020e-01,3.9215686e-03),(8.0392157e-01,1.3333333e-01,0),(7.7254902e-01,1.6470588e-01,0),(7.6470588e-01,1.6470588e-01,0),(7.5294118e-01,1.6862745e-01,3.9215686e-03),(7.2156863e-01,1.9607843e-01,3.9215686e-03),(7.0980392e-01,2e-01,3.9215686e-03),(6.8627451e-01,2.1176471e-01,3.9215686e-03),(6.6666667e-01,2.2745098e-01,3.9215686e-03),(6.5098039e-01,2.3921569e-01,7.8431373e-03),(6.2745098e-01,2.5098039e-01,7.8431373e-03),(6.0392157e-01,2.7058824e-01,7.8431373e-03),(5.8823529e-01,2.7843137e-01,7.8431373e-03),(5.6862745e-01,2.9019608e-01,3.9215686e-03),(5.4509804e-01,3.0980392e-01,3.9215686e-03),(5.2549020e-01,3.2156863e-01,7.8431373e-03),(5.0980392e-01,3.3333333e-01,1.1764706e-02),(4.9019608e-01,3.4901961e-01,1.5686275e-02),(4.6666667e-01,3.6078431e-01,1.1764706e-02),(4.4313725e-01,3.7647059e-01,1.1764706e-02),(4.2745098e-01,3.8823529e-01,1.5686275e-02),(4e-01,4.0392157e-01,1.5686275e-02),(3.7647059e-01,4.1960784e-01,2.3529412e-02),(3.6470588e-01,4.3529412e-01,2.7450980e-02),(3.4509804e-01,4.4705882e-01,2.7450980e-02),(3.2156863e-01,4.6274510e-01,2.7450980e-02),(3.0588235e-01,4.7450980e-01,3.1372549e-02),(2.9411765e-01,4.8627451e-01,3.1372549e-02),(2.7450980e-01,4.9803922e-01,3.1372549e-02),(2.5490196e-01,5.1372549e-01,3.5294118e-02),(2.4313725e-01,5.2549020e-01,3.9215686e-02),(2.1960784e-01,5.3725490e-01,4.7058824e-02),(2.0392157e-01,5.5294118e-01,4.7058824e-02),(1.8431373e-01,5.6470588e-01,4.7058824e-02),(1.8039216e-01,5.7647059e-01,5.4901961e-02),(1.6470588e-01,5.8823529e-01,5.4901961e-02),(1.4901961e-01,6.0392157e-01,5.4901961e-02),(1.3725490e-01,6.1568627e-01,5.4901961e-02),(1.2156863e-01,6.2745098e-01,5.8823529e-02),(1.0980392e-01,6.3529412e-01,6.6666667e-02),(1.1764706e-01,6.4313725e-01,6.6666667e-02),(1.1764706e-01,6.5490196e-01,7.0588235e-02),(1.0980392e-01,6.6274510e-01,7.0588235e-02),(1.0588235e-01,6.7450980e-01,7.8431373e-02),(9.4117647e-02,6.8235294e-01,8.2352941e-02),(7.4509804e-02,6.9019608e-01,8.2352941e-02),(5.0980392e-02,6.9803922e-01,8.6274510e-02),(5.4901961e-02,7.0588235e-01,9.0196078e-02),(3.5294118e-02,7.1764706e-01,8.2352941e-02),(7.8431373e-02,7.2941176e-01,9.4117647e-02),(7.4509804e-02,7.4117647e-01,1.0588235e-01),(3.5294118e-02,7.5686275e-01,1.0980392e-01),(5.8823529e-02,7.6862745e-01,1.1764706e-01),(7.8431373e-02,7.8039216e-01,1.2941176e-01),(7.4509804e-02,7.9215686e-01,1.3333333e-01),(1.0980392e-01,8e-01,1.4509804e-01),(1.2941176e-01,8.1176471e-01,1.5294118e-01),(1.5294118e-01,8.1960784e-01,1.6078431e-01),(1.7254902e-01,8.2745098e-01,1.6470588e-01),(1.9215686e-01,8.3921569e-01,1.7254902e-01),(2.1568627e-01,8.4313725e-01,1.8431373e-01),(2.5490196e-01,8.5098039e-01,1.9607843e-01),(2.7843137e-01,8.5882353e-01,2.0784314e-01),(3.1372549e-01,8.6666667e-01,2.1568627e-01),(3.4117647e-01,8.7450980e-01,2.2745098e-01),(3.6078431e-01,8.8235294e-01,2.3921569e-01),(3.9607843e-01,8.8627451e-01,2.4705882e-01),(4.1960784e-01,8.9019608e-01,2.5490196e-01),(4.6274510e-01,8.9019608e-01,2.6274510e-01),(5.0196078e-01,8.9803922e-01,2.7843137e-01),(5.2156863e-01,9.0588235e-01,2.8627451e-01),(5.4509804e-01,9.0980392e-01,3.0196078e-01),(5.6862745e-01,9.1372549e-01,3.1372549e-01),(5.9607843e-01,9.2156863e-01,3.2549020e-01),(6.3137255e-01,9.2156863e-01,3.3725490e-01),(6.5490196e-01,9.2941176e-01,3.4509804e-01),(6.7058824e-01,9.3333333e-01,3.5686275e-01),(6.9803922e-01,9.3333333e-01,3.6862745e-01),(7.2941176e-01,9.3333333e-01,3.8039216e-01),(7.4509804e-01,9.4117647e-01,3.9215686e-01),(7.5294118e-01,9.4509804e-01,4.0392157e-01),(7.7254902e-01,9.4901961e-01,4.1568627e-01),(7.9215686e-01,9.4901961e-01,4.2745098e-01),(8.1176471e-01,9.4509804e-01,4.5098039e-01),(8.3137255e-01,9.4509804e-01,4.7843137e-01),(8.3921569e-01,9.4509804e-01,5.0588235e-01),(8.5098039e-01,9.4509804e-01,5.2549020e-01),(8.5882353e-01,9.5294118e-01,5.4509804e-01),(8.6666667e-01,9.4901961e-01,5.7647059e-01),(8.7058824e-01,9.5294118e-01,6e-01),(8.7843137e-01,9.4901961e-01,6.2352941e-01),(8.8627451e-01,9.4901961e-01,6.5882353e-01),(8.9019608e-01,9.4509804e-01,6.8627451e-01),(8.9019608e-01,9.4117647e-01,7.0980392e-01),(8.9411765e-01,9.3725490e-01,7.3725490e-01),(8.9411765e-01,9.3333333e-01,7.5686275e-01),(8.9803922e-01,9.2941176e-01,7.8431373e-01),(8.9803922e-01,9.2549020e-01,8.0392157e-01),(9.0196078e-01,9.2156863e-01,8.2352941e-01),(9.0196078e-01,9.1764706e-01,8.4705882e-01),(9.0588235e-01,9.1372549e-01,8.6666667e-01),(9.0588235e-01,9.1372549e-01,8.8235294e-01)]
            colo  = LinearSegmentedColormap.from_list('name',colors=colo,N=256)
        # -------------------------
        if self.colo == 'roma':
            from matplotlib.colors import LinearSegmentedColormap
            colo  = [(0.49232, 0.090787, 7.635e-05),(0.49673, 0.1028, 0.0036753),(0.50113, 0.11403, 0.0071337),(0.50547, 0.12468, 0.010421),(0.50981, 0.13489, 0.013817),(0.51412, 0.14464, 0.016841),(0.5184, 0.15404, 0.01972),(0.52263, 0.16319, 0.022451),(0.52685, 0.17204, 0.025034),(0.53102, 0.18068, 0.027528),(0.53514, 0.18915, 0.030132),(0.53922, 0.19742, 0.032869),(0.54327, 0.20552, 0.035925),(0.54725, 0.21348, 0.038888),(0.5512, 0.22132, 0.041994),(0.5551, 0.22902, 0.045012),(0.55895, 0.23661, 0.047967),(0.56278, 0.24405, 0.051012),(0.56654, 0.25146, 0.053998),(0.57026, 0.25873, 0.057033),(0.57394, 0.26592, 0.060051),(0.57758, 0.27302, 0.063001),(0.58118, 0.28005, 0.065873),(0.58474, 0.28699, 0.068856),(0.58825, 0.29388, 0.071712),(0.59174, 0.3007, 0.074564),(0.59517, 0.30745, 0.077376),(0.59858, 0.31415, 0.080252),(0.60195, 0.3208, 0.083076),(0.60528, 0.32736, 0.085853),(0.60859, 0.33391, 0.088711),(0.61186, 0.34039, 0.091525),(0.61509, 0.34683, 0.094279),(0.61831, 0.35322, 0.096979),(0.62149, 0.35957, 0.099753),(0.62465, 0.3659, 0.10251),(0.62778, 0.37217, 0.10522),(0.6309, 0.37844, 0.10796),(0.63399, 0.38467, 0.11074),(0.63707, 0.39089, 0.11348),(0.64013, 0.39708, 0.11622),(0.64317, 0.40327, 0.11896),(0.64621, 0.40945, 0.12167),(0.64924, 0.41561, 0.12447),(0.65226, 0.42178, 0.12727),(0.65528, 0.42796, 0.13015),(0.6583, 0.43413, 0.13297),(0.66131, 0.44033, 0.13583),(0.66433, 0.44654, 0.13878),(0.66736, 0.45278, 0.14176),(0.6704, 0.45903, 0.14479),(0.67344, 0.4653, 0.14785),(0.67649, 0.47163, 0.15097),(0.67955, 0.47797, 0.15416),(0.68264, 0.48435, 0.15743),(0.68574, 0.49078, 0.16079),(0.68885, 0.49724, 0.16425),(0.69198, 0.50374, 0.16775),(0.69512, 0.5103, 0.17137),(0.69828, 0.5169, 0.17511),(0.70147, 0.52356, 0.17896),(0.70468, 0.53026, 0.1829),(0.70791, 0.53702, 0.18701),(0.71116, 0.54382, 0.19123),(0.71443, 0.55069, 0.1956),(0.71772, 0.55762, 0.20011),(0.72103, 0.56459, 0.20483),(0.72437, 0.57163, 0.20968),(0.72772, 0.57873, 0.21471),(0.73109, 0.58589, 0.21995),(0.73448, 0.5931, 0.22535),(0.73788, 0.60036, 0.23097),(0.7413, 0.6077, 0.23681),(0.74473, 0.61507, 0.24282),(0.74818, 0.62252, 0.2491),(0.75162, 0.63001, 0.2556),(0.75507, 0.63756, 0.26233),(0.75852, 0.64515, 0.26932),(0.76196, 0.65279, 0.27655),(0.76541, 0.66047, 0.28401),(0.76882, 0.6682, 0.29176),(0.77222, 0.67595, 0.29974),(0.7756, 0.68373, 0.30798),(0.77894, 0.69153, 0.3165),(0.78224, 0.69935, 0.32526),(0.78549, 0.70719, 0.3343),(0.78869, 0.71502, 0.34356),(0.79181, 0.72284, 0.35309),(0.79486, 0.73065, 0.36285),(0.79783, 0.73844, 0.37284),(0.8007, 0.74619, 0.38307),(0.80346, 0.75389, 0.3935),(0.80611, 0.76154, 0.40413),(0.80862, 0.76911, 0.41495),(0.811, 0.77662, 0.42594),(0.81322, 0.78403, 0.43709),(0.81528, 0.79132, 0.44836),(0.81717, 0.79851, 0.45976),(0.81886, 0.80556, 0.47125),(0.82037, 0.81248, 0.48281),(0.82168, 0.81924, 0.49444),(0.82276, 0.82584, 0.50608),(0.82361, 0.83227, 0.51775),(0.82424, 0.83851, 0.5294),(0.82462, 0.84455, 0.541),(0.82475, 0.85039, 0.55256),(0.82463, 0.85602, 0.56404),(0.82425, 0.86143, 0.57541),(0.82361, 0.86661, 0.58666),(0.82269, 0.87156, 0.59777),(0.8215, 0.87627, 0.60873),(0.82003, 0.88074, 0.61951),(0.81829, 0.88497, 0.6301),(0.81627, 0.88895, 0.64049),(0.81395, 0.89268, 0.65066),(0.81137, 0.89616, 0.6606),(0.8085, 0.89939, 0.67031),(0.80535, 0.90236, 0.67976),(0.80192, 0.90509, 0.68897),(0.79821, 0.90757, 0.69791),(0.79423, 0.90979, 0.70659),(0.78996, 0.91177, 0.71498),(0.78543, 0.91351, 0.72311),(0.78062, 0.91499, 0.73095),(0.77555, 0.91624, 0.73852),(0.77022, 0.91725, 0.7458),(0.76462, 0.91801, 0.7528),(0.75877, 0.91854, 0.75952),(0.75266, 0.91884, 0.76596),(0.74632, 0.9189, 0.77211),(0.73973, 0.91874, 0.77798),(0.7329, 0.91835, 0.78357),(0.72583, 0.91774, 0.78889),(0.71854, 0.9169, 0.79394),(0.71103, 0.91583, 0.79871),(0.7033, 0.91455, 0.80321),(0.69536, 0.91305, 0.80746),(0.68722, 0.91134, 0.81144),(0.67887, 0.90941, 0.81517),(0.67035, 0.90728, 0.81864),(0.66163, 0.90493, 0.82188),(0.65274, 0.90238, 0.82486),(0.64368, 0.89962, 0.82761),(0.63446, 0.89666, 0.83014),(0.62509, 0.8935, 0.83242),(0.61557, 0.89015, 0.83449),(0.60591, 0.8866, 0.83634),(0.59614, 0.88285, 0.83797),(0.58626, 0.87892, 0.83939),(0.57628, 0.87481, 0.84061),(0.56619, 0.87052, 0.84163),(0.55602, 0.86606, 0.84246),(0.54581, 0.86142, 0.84309),(0.53553, 0.85662, 0.84354),(0.52522, 0.85166, 0.84381),(0.51488, 0.84654, 0.84391),(0.50453, 0.84129, 0.84384),(0.49418, 0.83588, 0.8436),(0.48384, 0.83035, 0.84322),(0.47354, 0.82468, 0.84268),(0.46329, 0.8189, 0.84199),(0.45311, 0.81301, 0.84116),(0.44301, 0.80702, 0.8402),(0.43298, 0.80092, 0.83911),(0.42306, 0.79474, 0.8379),(0.41327, 0.78847, 0.83657),(0.4036, 0.78214, 0.83513),(0.39406, 0.77573, 0.8336),(0.38468, 0.76926, 0.83196),(0.37547, 0.76275, 0.83023),(0.36645, 0.75619, 0.82841),(0.35759, 0.74958, 0.82651),(0.34892, 0.74296, 0.82454),(0.34045, 0.73629, 0.8225),(0.33219, 0.72962, 0.82039),(0.32411, 0.72292, 0.81823),(0.31628, 0.71622, 0.81602),(0.30865, 0.70951, 0.81375),(0.30122, 0.7028, 0.81144),(0.29404, 0.6961, 0.80909),(0.28707, 0.6894, 0.8067),(0.28032, 0.68271, 0.80427),(0.27382, 0.67603, 0.80182),(0.26748, 0.66938, 0.79934),(0.26141, 0.66274, 0.79684),(0.25554, 0.65612, 0.79432),(0.24986, 0.64952, 0.79178),(0.2444, 0.64294, 0.78923),(0.23916, 0.6364, 0.78667),(0.2341, 0.62987, 0.78409),(0.22923, 0.62338, 0.7815),(0.22453, 0.61692, 0.77891),(0.22006, 0.61047, 0.77631),(0.21573, 0.60407, 0.77371),(0.21157, 0.59767, 0.77111),(0.20755, 0.59132, 0.7685),(0.20371, 0.58499, 0.7659),(0.19997, 0.57868, 0.76329),(0.19644, 0.5724, 0.76069),(0.19299, 0.56614, 0.75809),(0.18968, 0.55991, 0.75548),(0.18649, 0.55369, 0.75287),(0.1834, 0.5475, 0.75028),(0.18042, 0.54132, 0.74768),(0.17759, 0.53516, 0.74507),(0.1748, 0.52903, 0.74248),(0.17208, 0.52288, 0.73988),(0.1695, 0.51675, 0.73727),(0.16696, 0.51063, 0.73467),(0.16448, 0.50452, 0.73207),(0.16209, 0.4984, 0.72945),(0.1597, 0.49226, 0.72684),(0.15741, 0.48613, 0.72421),(0.15518, 0.47999, 0.72158),(0.15296, 0.47383, 0.71895),(0.1508, 0.46766, 0.71631),(0.14865, 0.46147, 0.71364),(0.14655, 0.45526, 0.71098),(0.14449, 0.44903, 0.70829),(0.14241, 0.44276, 0.70559),(0.14034, 0.43647, 0.70289),(0.13831, 0.43014, 0.70016),(0.13621, 0.42378, 0.69741),(0.1342, 0.41741, 0.69465),(0.13213, 0.41098, 0.69188),(0.13009, 0.40452, 0.68909),(0.12797, 0.39804, 0.68628),(0.12586, 0.39152, 0.68345),(0.12366, 0.38495, 0.6806),(0.12148, 0.37835, 0.67775),(0.11929, 0.37171, 0.67486),(0.117, 0.36505, 0.67196),(0.11465, 0.35834, 0.66905),(0.11232, 0.3516, 0.66611),(0.10989, 0.34482, 0.66316),(0.10732, 0.33799, 0.66018),(0.10464, 0.33113, 0.6572),(0.10195, 0.32424, 0.65418),(0.099119, 0.3173, 0.65115),(0.096135, 0.31034, 0.6481),(0.093031, 0.3033, 0.64503),(0.089832, 0.29624, 0.64195),(0.086378, 0.28914, 0.63884),(0.082771, 0.28199, 0.63572),(0.078888, 0.27477, 0.63257),(0.074823, 0.26751, 0.6294),(0.070429, 0.26024, 0.62622),(0.065707, 0.25289, 0.62301),(0.060588, 0.24547, 0.61979),(0.054957, 0.23804, 0.61654),(0.048861, 0.23052, 0.61327),(0.041963, 0.22298, 0.60999),(0.034076, 0.21534, 0.6067),(0.026246, 0.20768, 0.60338),(0.018222, 0.19991, 0.60005),(0.0098239, 0.19213, 0.5967)]
            colo  = LinearSegmentedColormap.from_list('name',colors=colo,N=256)
        # -------------------------
        if self.colo == 'hawaii':
            # by www.fabiocrameri.ch/colourmaps
            from matplotlib.colors import LinearSegmentedColormap
            colo  = [(0.55054, 0.006842, 0.45198),(0.55149, 0.015367, 0.44797),(0.55243, 0.023795, 0.444),(0.55333, 0.032329, 0.44002),(0.55423, 0.04117, 0.43606),(0.5551, 0.049286, 0.43213),(0.55595, 0.056667, 0.42819),(0.5568, 0.063525, 0.42427),(0.55762, 0.06997, 0.42038),(0.55841, 0.076028, 0.41651),(0.55921, 0.081936, 0.41266),(0.55999, 0.087507, 0.40882),(0.56075, 0.092811, 0.40501),(0.56149, 0.098081, 0.40124),(0.56224, 0.10313, 0.39747),(0.56295, 0.108, 0.39374),(0.56366, 0.11287, 0.39002),(0.56435, 0.11753, 0.38634),(0.56503, 0.12212, 0.3827),(0.56571, 0.12668, 0.37907),(0.56638, 0.13117, 0.37547),(0.56704, 0.13554, 0.3719),(0.56768, 0.13987, 0.36838),(0.56831, 0.1442, 0.36486),(0.56894, 0.14842, 0.36138),(0.56956, 0.15262, 0.35794),(0.57017, 0.15681, 0.35452),(0.57078, 0.16093, 0.35113),(0.57138, 0.16501, 0.34776),(0.57197, 0.16912, 0.34442),(0.57256, 0.17313, 0.34112),(0.57314, 0.17717, 0.33784),(0.57371, 0.18114, 0.3346),(0.57428, 0.18515, 0.33136),(0.57484, 0.18909, 0.32817),(0.57541, 0.19304, 0.32499),(0.57597, 0.19698, 0.32185),(0.57652, 0.20085, 0.31874),(0.57706, 0.20478, 0.31565),(0.5776, 0.20866, 0.31256),(0.57814, 0.21254, 0.30954),(0.57868, 0.21643, 0.30652),(0.57921, 0.22029, 0.3035),(0.57975, 0.22411, 0.30052),(0.58027, 0.22798, 0.29757),(0.58079, 0.23182, 0.29462),(0.58131, 0.23565, 0.29171),(0.58183, 0.23946, 0.28881),(0.58235, 0.24327, 0.28591),(0.58287, 0.2471, 0.28307),(0.58339, 0.25092, 0.2802),(0.5839, 0.25474, 0.27738),(0.58442, 0.25853, 0.27455),(0.58493, 0.26234, 0.27174),(0.58544, 0.26616, 0.26898),(0.58595, 0.26997, 0.2662),(0.58646, 0.27377, 0.26344),(0.58696, 0.27758, 0.26068),(0.58747, 0.28137, 0.25793),(0.58797, 0.28518, 0.25522),(0.58848, 0.28901, 0.25249),(0.58898, 0.29282, 0.24977),(0.58949, 0.29665, 0.24708),(0.59, 0.30047, 0.24438),(0.59051, 0.3043, 0.24172),(0.59102, 0.30814, 0.23903),(0.59153, 0.31197, 0.23638),(0.59204, 0.31585, 0.23369),(0.59255, 0.3197, 0.23106),(0.59305, 0.32356, 0.22842),(0.59356, 0.32743, 0.22577),(0.59407, 0.33131, 0.22313),(0.59458, 0.33523, 0.22051),(0.5951, 0.33913, 0.21787),(0.59561, 0.34305, 0.21523),(0.59613, 0.34698, 0.21261),(0.59664, 0.35092, 0.20999),(0.59716, 0.35488, 0.20739),(0.59768, 0.35883, 0.20478),(0.5982, 0.36282, 0.20215),(0.59872, 0.36683, 0.19953),(0.59925, 0.37084, 0.19696),(0.59977, 0.37488, 0.19437),(0.60029, 0.37893, 0.19174),(0.60082, 0.38301, 0.18915),(0.60135, 0.38709, 0.18655),(0.60187, 0.39122, 0.18395),(0.6024, 0.39535, 0.18134),(0.60293, 0.39949, 0.17878),(0.60346, 0.40368, 0.17616),(0.604, 0.40787, 0.17359),(0.60452, 0.4121, 0.17101),(0.60504, 0.41635, 0.16844),(0.60556, 0.42062, 0.16585),(0.60608, 0.42493, 0.16332),(0.60661, 0.42925, 0.16073),(0.60713, 0.4336, 0.1582),(0.60764, 0.438, 0.15565),(0.60814, 0.44241, 0.15309),(0.60864, 0.44685, 0.15058),(0.60913, 0.45132, 0.14807),(0.60961, 0.45583, 0.14561),(0.61008, 0.46036, 0.14312),(0.61054, 0.46493, 0.14069),(0.61099, 0.46954, 0.13827),(0.61142, 0.47417, 0.13583),(0.61183, 0.47884, 0.13351),(0.61223, 0.48354, 0.13121),(0.6126, 0.48829, 0.12892),(0.61295, 0.49305, 0.12672),(0.61327, 0.49788, 0.12457),(0.61357, 0.5027, 0.12249),(0.61384, 0.50759, 0.12051),(0.61407, 0.5125, 0.11867),(0.61426, 0.51746, 0.11685),(0.61442, 0.52243, 0.11516),(0.61453, 0.52746, 0.11366),(0.61459, 0.53251, 0.11227),(0.61461, 0.53759, 0.11103),(0.61457, 0.54271, 0.11),(0.61447, 0.54785, 0.10911),(0.61431, 0.55302, 0.10842),(0.61408, 0.55821, 0.10801),(0.61379, 0.56345, 0.10785),(0.61342, 0.56868, 0.10794),(0.61297, 0.57395, 0.10831),(0.61245, 0.57923, 0.10903),(0.61184, 0.58452, 0.11004),(0.61115, 0.58982, 0.11132),(0.61035, 0.59513, 0.11296),(0.60947, 0.60044, 0.11486),(0.60849, 0.60575, 0.11717),(0.60741, 0.61106, 0.11981),(0.60622, 0.61635, 0.12276),(0.60493, 0.62162, 0.12612),(0.60354, 0.62688, 0.12976),(0.60203, 0.63211, 0.13369),(0.60041, 0.63731, 0.13797),(0.59869, 0.64247, 0.1425),(0.59686, 0.64759, 0.14733),(0.59492, 0.65266, 0.15242),(0.59287, 0.6577, 0.15779),(0.59071, 0.66267, 0.16342),(0.58844, 0.66758, 0.16926),(0.58608, 0.67243, 0.17528),(0.58361, 0.67721, 0.18151),(0.58105, 0.68192, 0.18799),(0.57839, 0.68656, 0.19459),(0.57565, 0.69112, 0.20131),(0.57281, 0.69561, 0.20824),(0.56988, 0.70002, 0.21528),(0.56689, 0.70435, 0.22247),(0.56381, 0.7086, 0.22974),(0.56066, 0.71275, 0.23717),(0.55746, 0.71684, 0.24462),(0.55418, 0.72084, 0.25222),(0.55085, 0.72477, 0.25987),(0.54747, 0.7286, 0.26757),(0.54404, 0.73238, 0.27539),(0.54057, 0.73606, 0.28324),(0.53707, 0.73968, 0.29114),(0.53351, 0.74323, 0.29909),(0.52994, 0.7467, 0.30708),(0.52633, 0.75011, 0.31511),(0.5227, 0.75346, 0.32319),(0.51905, 0.75675, 0.33128),(0.51537, 0.75998, 0.33944),(0.51168, 0.76316, 0.3476),(0.50799, 0.76629, 0.35578),(0.50428, 0.76937, 0.36398),(0.50055, 0.77241, 0.37222),(0.49682, 0.77541, 0.38048),(0.49309, 0.77836, 0.38876),(0.48935, 0.78129, 0.39705),(0.48561, 0.78418, 0.40538),(0.48188, 0.78704, 0.41371),(0.47814, 0.78987, 0.42206),(0.47441, 0.79267, 0.43044),(0.47068, 0.79546, 0.43882),(0.46695, 0.79822, 0.44724),(0.46322, 0.80096, 0.45567),(0.45952, 0.80369, 0.46412),(0.45581, 0.80641, 0.47258),(0.45212, 0.80911, 0.48105),(0.44844, 0.8118, 0.48955),(0.44477, 0.81447, 0.49809),(0.44111, 0.81714, 0.50662),(0.43749, 0.8198, 0.51517),(0.43386, 0.82246, 0.52375),(0.43028, 0.82511, 0.53235),(0.42672, 0.82776, 0.54096),(0.42319, 0.8304, 0.5496),(0.41971, 0.83304, 0.55824),(0.41626, 0.83567, 0.56692),(0.41287, 0.83831, 0.57561),(0.40952, 0.84094, 0.58431),(0.40624, 0.84356, 0.59304),(0.40304, 0.84619, 0.60178),(0.3999, 0.84882, 0.61054),(0.39687, 0.85144, 0.61932),(0.39395, 0.85406, 0.6281),(0.39115, 0.85668, 0.63691),(0.38847, 0.8593, 0.64571),(0.38593, 0.86192, 0.65453),(0.38359, 0.86453, 0.66337),(0.38141, 0.86713, 0.6722),(0.37942, 0.86973, 0.68102),(0.37767, 0.87232, 0.68986),(0.37617, 0.87491, 0.69869),(0.37492, 0.87748, 0.70751),(0.37398, 0.88005, 0.71632),(0.37334, 0.8826, 0.72511),(0.37304, 0.88514, 0.73387),(0.37311, 0.88765, 0.7426),(0.37357, 0.89016, 0.7513),(0.37444, 0.89264, 0.75995),(0.37572, 0.8951, 0.76855),(0.37747, 0.89752, 0.7771),(0.37967, 0.89992, 0.78557),(0.38235, 0.90229, 0.79397),(0.38553, 0.90462, 0.80228),(0.38921, 0.90691, 0.8105),(0.39338, 0.90916, 0.81862),(0.39807, 0.91137, 0.82663),(0.40326, 0.91353, 0.83451),(0.40893, 0.91563, 0.84226),(0.41508, 0.91769, 0.84986),(0.4217, 0.91968, 0.85731),(0.42879, 0.92161, 0.86461),(0.43631, 0.92349, 0.87173),(0.44423, 0.92529, 0.87868),(0.45254, 0.92703, 0.88545),(0.4612, 0.9287, 0.89204),(0.47021, 0.93031, 0.89842),(0.47952, 0.93184, 0.90462),(0.4891, 0.9333, 0.91062),(0.49895, 0.93469, 0.91641),(0.50902, 0.936, 0.92201),(0.51928, 0.93725, 0.92739),(0.52972, 0.93842, 0.93259),(0.54029, 0.93952, 0.93759),(0.551, 0.94055, 0.9424),(0.5618, 0.94151, 0.94702),(0.57269, 0.94241, 0.95146),(0.58362, 0.94324, 0.95573),(0.59461, 0.94402, 0.95982),(0.60561, 0.94473, 0.96377),(0.61664, 0.94539, 0.96756),(0.62765, 0.94599, 0.97121),(0.63865, 0.94654, 0.97474),(0.64962, 0.94705, 0.97815),(0.66055, 0.94751, 0.98145),(0.67144, 0.94793, 0.98465),(0.68228, 0.94832, 0.98777),(0.69306, 0.94866, 0.9908),(0.70378, 0.94898, 0.99377)]
            colo  = LinearSegmentedColormap.from_list('name',colors=colo,N=256)
        # -------------------------
        if self.colo == 'lisbon':
            # by www.fabiocrameri.ch/colourmaps
            from matplotlib.colors import LinearSegmentedColormap
            colo  = [(0.90019, 0.89986, 0.99991),(0.88957, 0.8921, 0.9936),(0.87895, 0.88435, 0.9873),(0.86836, 0.8766, 0.981),(0.85776, 0.86888, 0.97471),(0.84718, 0.86115, 0.96843),(0.83662, 0.85344, 0.96215),(0.82607, 0.84574, 0.95589),(0.81553, 0.83806, 0.94962),(0.80499, 0.83038, 0.94336),(0.79448, 0.82271, 0.93711),(0.78398, 0.81505, 0.93086),(0.77348, 0.8074, 0.92462),(0.763, 0.79976, 0.91838),(0.75253, 0.79212, 0.91216),(0.74208, 0.7845, 0.90593),(0.73164, 0.77688, 0.89972),(0.72122, 0.76927, 0.8935),(0.71081, 0.76167, 0.8873),(0.70041, 0.75408, 0.8811),(0.69002, 0.74649, 0.87491),(0.67965, 0.73892, 0.86872),(0.6693, 0.73134, 0.86254),(0.65896, 0.72378, 0.85636),(0.64863, 0.71623, 0.85019),(0.63832, 0.70868, 0.84402),(0.62803, 0.70113, 0.83787),(0.61774, 0.6936, 0.83171),(0.60748, 0.68607, 0.82555),(0.59723, 0.67854, 0.8194),(0.58699, 0.67103, 0.81326),(0.57678, 0.66352, 0.80713),(0.56658, 0.65601, 0.80098),(0.55639, 0.6485, 0.79485),(0.54623, 0.641, 0.78872),(0.53607, 0.63351, 0.78258),(0.52594, 0.62601, 0.77644),(0.51581, 0.61852, 0.7703),(0.50571, 0.61104, 0.76416),(0.49564, 0.60355, 0.75801),(0.48558, 0.59606, 0.75185),(0.47555, 0.58857, 0.74568),(0.46551, 0.58109, 0.73951),(0.45552, 0.57361, 0.73331),(0.44554, 0.56612, 0.7271),(0.4356, 0.55862, 0.72086),(0.42566, 0.55113, 0.71459),(0.41576, 0.54363, 0.70831),(0.40589, 0.53612, 0.70197),(0.39604, 0.52861, 0.69561),(0.38621, 0.52108, 0.6892),(0.37644, 0.51355, 0.68272),(0.3667, 0.506, 0.6762),(0.357, 0.49846, 0.66961),(0.34734, 0.4909, 0.66295),(0.33772, 0.48331, 0.65622),(0.32816, 0.47573, 0.6494),(0.31867, 0.46812, 0.64248),(0.30926, 0.46051, 0.63547),(0.29989, 0.45291, 0.62837),(0.29062, 0.44528, 0.62115),(0.28145, 0.43766, 0.61382),(0.27237, 0.43002, 0.60638),(0.26344, 0.42238, 0.59882),(0.25462, 0.41477, 0.59114),(0.2459, 0.40715, 0.58333),(0.23739, 0.39954, 0.57541),(0.22901, 0.39196, 0.56736),(0.22082, 0.3844, 0.55919),(0.21278, 0.37688, 0.55092),(0.20499, 0.36938, 0.54253),(0.1974, 0.36193, 0.53402),(0.19002, 0.35453, 0.52543),(0.18288, 0.34718, 0.51674),(0.17599, 0.33988, 0.50798),(0.1694, 0.33265, 0.49912),(0.16302, 0.32546, 0.49021),(0.15689, 0.31838, 0.48124),(0.15103, 0.31136, 0.47222),(0.14549, 0.30442, 0.46315),(0.14012, 0.29756, 0.45407),(0.13509, 0.29078, 0.44496),(0.1303, 0.28408, 0.43583),(0.12572, 0.27748, 0.42669),(0.12135, 0.27096, 0.41756),(0.11727, 0.2645, 0.40842),(0.11345, 0.25812, 0.3993),(0.10981, 0.25186, 0.39021),(0.10635, 0.24564, 0.38115),(0.10306, 0.23952, 0.37208),(0.099941, 0.23345, 0.36307),(0.097002, 0.2275, 0.35409),(0.094303, 0.22159, 0.34515),(0.091713, 0.21576, 0.33624),(0.08922, 0.20999, 0.32738),(0.086919, 0.20432, 0.31857),(0.084717, 0.19867, 0.30982),(0.082644, 0.19313, 0.30108),(0.080696, 0.18768, 0.29243),(0.078849, 0.18223, 0.28382),(0.077157, 0.17692, 0.27529),(0.075616, 0.17166, 0.26679),(0.074219, 0.16651, 0.25838),(0.072907, 0.16146, 0.25002),(0.071722, 0.15647, 0.24178),(0.070637, 0.15156, 0.23358),(0.069756, 0.14679, 0.22551),(0.068993, 0.14217, 0.21752),(0.068301, 0.13767, 0.20963),(0.067772, 0.13328, 0.20186),(0.067395, 0.12903, 0.19427),(0.067165, 0.12499, 0.18675),(0.067086, 0.1211, 0.17943),(0.06716, 0.11745, 0.17227),(0.06739, 0.114, 0.1653),(0.067779, 0.11082, 0.1586),(0.068337, 0.10781, 0.15205),(0.069084, 0.1051, 0.14582),(0.069909, 0.10272, 0.13976),(0.070958, 0.10059, 0.13409),(0.07215, 0.098812, 0.12866),(0.073639, 0.097347, 0.12356),(0.075176, 0.096199, 0.11887),(0.076956, 0.095493, 0.11442),(0.078977, 0.095119, 0.11047),(0.081272, 0.095095, 0.10685),(0.08373, 0.095427, 0.10358),(0.086376, 0.0961, 0.10069),(0.089318, 0.097212, 0.098263),(0.092445, 0.098697, 0.096142),(0.095823, 0.1005, 0.094539),(0.099434, 0.1027, 0.093176),(0.10331, 0.10518, 0.092312),(0.10736, 0.10803, 0.091807),(0.11165, 0.11122, 0.091623),(0.11615, 0.11461, 0.091779),(0.12079, 0.11839, 0.092234),(0.12572, 0.1223, 0.092972),(0.13079, 0.12655, 0.094115),(0.13596, 0.13101, 0.09548),(0.14139, 0.13561, 0.097052),(0.14689, 0.14047, 0.098938),(0.15255, 0.1455, 0.10101),(0.15837, 0.15062, 0.10334),(0.16427, 0.15594, 0.1058),(0.17026, 0.16138, 0.10841),(0.17633, 0.16692, 0.11128),(0.18252, 0.17255, 0.11419),(0.18882, 0.17834, 0.11728),(0.19515, 0.18416, 0.12049),(0.20155, 0.19009, 0.12381),(0.20805, 0.19611, 0.12723),(0.21458, 0.20216, 0.13079),(0.22119, 0.20831, 0.13438),(0.22783, 0.2145, 0.13805),(0.23454, 0.22078, 0.14177),(0.24127, 0.22707, 0.14559),(0.24807, 0.23339, 0.14942),(0.2549, 0.2398, 0.1533),(0.26176, 0.24624, 0.15725),(0.26868, 0.25273, 0.16129),(0.27563, 0.25926, 0.16528),(0.28262, 0.26581, 0.16941),(0.28963, 0.27238, 0.17349),(0.29669, 0.27902, 0.17766),(0.30376, 0.28566, 0.18179),(0.3109, 0.29236, 0.18603),(0.31804, 0.29909, 0.19023),(0.32522, 0.30585, 0.19452),(0.33245, 0.31261, 0.19876),(0.3397, 0.31943, 0.20308),(0.34697, 0.32626, 0.20741),(0.35426, 0.33314, 0.21177),(0.3616, 0.34004, 0.21615),(0.36896, 0.34696, 0.22055),(0.37635, 0.3539, 0.22493),(0.38376, 0.36087, 0.22938),(0.3912, 0.36788, 0.23384),(0.39866, 0.37491, 0.23833),(0.40617, 0.38197, 0.24285),(0.41369, 0.38907, 0.24741),(0.42124, 0.39618, 0.25198),(0.42882, 0.40333, 0.25657),(0.43643, 0.41052, 0.26122),(0.44408, 0.41772, 0.2659),(0.45174, 0.42496, 0.27062),(0.45943, 0.43224, 0.27538),(0.46716, 0.43954, 0.28017),(0.47492, 0.44688, 0.28502),(0.48269, 0.45427, 0.28994),(0.49051, 0.46168, 0.29492),(0.49836, 0.46915, 0.29998),(0.50622, 0.47664, 0.3051),(0.51414, 0.48418, 0.31031),(0.52207, 0.49178, 0.3156),(0.53005, 0.4994, 0.32098),(0.53805, 0.50709, 0.32645),(0.54608, 0.51482, 0.33206),(0.55413, 0.52259, 0.33776),(0.56223, 0.53042, 0.34359),(0.57033, 0.5383, 0.34955),(0.57847, 0.54623, 0.35565),(0.58663, 0.5542, 0.36188),(0.59481, 0.56223, 0.36826),(0.60301, 0.57029, 0.37478),(0.61122, 0.57841, 0.38147),(0.61944, 0.58657, 0.38831),(0.62766, 0.59478, 0.39532),(0.63589, 0.60302, 0.40247),(0.64412, 0.6113, 0.40981),(0.65234, 0.61961, 0.41731),(0.66055, 0.62795, 0.42496),(0.66876, 0.63632, 0.43277),(0.67694, 0.6447, 0.44072),(0.6851, 0.6531, 0.44885),(0.69323, 0.66153, 0.45711),(0.70133, 0.66997, 0.46551),(0.70942, 0.67841, 0.47407),(0.71746, 0.68685, 0.48274),(0.72547, 0.6953, 0.49156),(0.73343, 0.70375, 0.50046),(0.74136, 0.7122, 0.5095),(0.74926, 0.72065, 0.51864),(0.75712, 0.72909, 0.52786),(0.76495, 0.73752, 0.53719),(0.77273, 0.74596, 0.5466),(0.78049, 0.75439, 0.55608),(0.78821, 0.7628, 0.56564),(0.7959, 0.77122, 0.57527),(0.80357, 0.77962, 0.58497),(0.81121, 0.78803, 0.59472),(0.81882, 0.79643, 0.60453),(0.82642, 0.80483, 0.61437),(0.834, 0.81323, 0.62428),(0.84156, 0.82163, 0.63423),(0.84911, 0.83004, 0.64421),(0.85665, 0.83844, 0.65423),(0.86419, 0.84685, 0.66429),(0.87171, 0.85527, 0.67438),(0.87923, 0.8637, 0.6845),(0.88675, 0.87213, 0.69466),(0.89427, 0.88056, 0.70484),(0.90179, 0.88902, 0.71505),(0.90931, 0.89748, 0.7253),(0.91683, 0.90595, 0.73555),(0.92435, 0.91443, 0.74584),(0.93188, 0.92293, 0.75615),(0.93942, 0.93143, 0.76649),(0.94696, 0.93996, 0.77685),(0.9545, 0.94849, 0.78723),(0.96204, 0.95704, 0.79763),(0.9696, 0.9656, 0.80806),(0.97716, 0.97418, 0.81851),(0.98473, 0.98277, 0.82899),(0.9923, 0.99138, 0.83948),(0.99987, 1, 0.84999)]
            colo  = LinearSegmentedColormap.from_list('name',colors=colo,N=256)
        # -------------------------
        if self.colo == 'bam':
            # by www.fabiocrameri.ch/colourmaps
            from matplotlib.colors import LinearSegmentedColormap
            colo  = [(0.39622, 0.0081199, 0.29605),(0.40507, 0.018136, 0.30473),(0.41391, 0.028663, 0.31342),(0.4227, 0.0401, 0.32208),(0.43148, 0.051043, 0.33072),(0.44019, 0.06117, 0.33935),(0.44885, 0.070776, 0.34792),(0.45745, 0.079825, 0.35645),(0.46599, 0.088578, 0.36492),(0.47448, 0.096961, 0.37335),(0.48289, 0.10516, 0.38173),(0.49125, 0.11322, 0.39005),(0.49951, 0.12098, 0.39832),(0.50774, 0.12868, 0.40652),(0.51586, 0.13623, 0.41466),(0.52394, 0.14372, 0.42273),(0.53194, 0.15107, 0.43074),(0.53985, 0.15837, 0.43868),(0.5477, 0.16553, 0.44655),(0.55546, 0.17269, 0.45435),(0.56315, 0.17977, 0.46207),(0.57075, 0.1868, 0.46972),(0.57827, 0.19379, 0.47728),(0.58572, 0.20069, 0.48477),(0.59306, 0.2076, 0.49219),(0.60032, 0.21444, 0.49952),(0.6075, 0.22126, 0.50677),(0.61457, 0.22804, 0.51394),(0.62157, 0.23479, 0.52102),(0.62847, 0.2415, 0.52801),(0.63526, 0.24819, 0.53492),(0.64197, 0.25485, 0.54174),(0.64857, 0.26148, 0.54848),(0.65507, 0.26808, 0.55512),(0.66148, 0.27469, 0.56168),(0.66779, 0.28127, 0.56814),(0.67398, 0.28785, 0.57452),(0.68008, 0.29442, 0.58082),(0.68609, 0.301, 0.58704),(0.69201, 0.30758, 0.59318),(0.69782, 0.31419, 0.59926),(0.70357, 0.32083, 0.60526),(0.70924, 0.32749, 0.61122),(0.71483, 0.33423, 0.61713),(0.72036, 0.341, 0.623),(0.72584, 0.34786, 0.62883),(0.73125, 0.35481, 0.63464),(0.73661, 0.36183, 0.64043),(0.74193, 0.36895, 0.6462),(0.7472, 0.37618, 0.65196),(0.75241, 0.38351, 0.6577),(0.75758, 0.39094, 0.66342),(0.7627, 0.39847, 0.66912),(0.76776, 0.40612, 0.67481),(0.77276, 0.41386, 0.68048),(0.77771, 0.4217, 0.68613),(0.78259, 0.42965, 0.69176),(0.78741, 0.4377, 0.69736),(0.79216, 0.44581, 0.70293),(0.79684, 0.45404, 0.70848),(0.80146, 0.46233, 0.71399),(0.80601, 0.47072, 0.71947),(0.81048, 0.47917, 0.72492),(0.81488, 0.48769, 0.73033),(0.81921, 0.49627, 0.73571),(0.82346, 0.50492, 0.74104),(0.82765, 0.51362, 0.74635),(0.83177, 0.52236, 0.75162),(0.83581, 0.53116, 0.75684),(0.83979, 0.53999, 0.76202),(0.84369, 0.54887, 0.76717),(0.84754, 0.55777, 0.77228),(0.85131, 0.56669, 0.77736),(0.85504, 0.57564, 0.78239),(0.85869, 0.5846, 0.78739),(0.8623, 0.59357, 0.79234),(0.86584, 0.60255, 0.79726),(0.86933, 0.61153, 0.80215),(0.87276, 0.62051, 0.807),(0.87615, 0.62948, 0.8118),(0.87948, 0.63844, 0.81658),(0.88277, 0.64739, 0.82131),(0.88602, 0.65632, 0.82601),(0.88922, 0.66521, 0.83067),(0.89238, 0.67407, 0.83528),(0.89549, 0.6829, 0.83986),(0.89856, 0.69169, 0.84439),(0.90159, 0.70042, 0.84888),(0.90457, 0.70911, 0.85332),(0.90751, 0.71772, 0.85771),(0.9104, 0.72627, 0.86206),(0.91325, 0.73474, 0.86634),(0.91604, 0.74314, 0.87055),(0.9188, 0.75144, 0.87471),(0.9215, 0.75964, 0.87881),(0.92415, 0.76775, 0.88283),(0.92674, 0.77576, 0.88678),(0.92928, 0.78365, 0.89064),(0.93177, 0.79142, 0.89443),(0.93419, 0.79908, 0.89813),(0.93656, 0.80661, 0.90174),(0.93885, 0.814, 0.90525),(0.94108, 0.82127, 0.90866),(0.94324, 0.82839, 0.91197),(0.94533, 0.83537, 0.91516),(0.94733, 0.84221, 0.91824),(0.94926, 0.84888, 0.9212),(0.95111, 0.85541, 0.92403),(0.95287, 0.86176, 0.92672),(0.95453, 0.86794, 0.92927),(0.9561, 0.87394, 0.93168),(0.95757, 0.87977, 0.93392),(0.95894, 0.8854, 0.93602),(0.9602, 0.89084, 0.93793),(0.96134, 0.89607, 0.93967),(0.96236, 0.9011, 0.94123),(0.96327, 0.90592, 0.94261),(0.96405, 0.91051, 0.94378),(0.96471, 0.91487, 0.94476),(0.96523, 0.919, 0.94553),(0.96563, 0.92291, 0.9461),(0.96588, 0.92657, 0.94645),(0.966, 0.92999, 0.94659),(0.96599, 0.93316, 0.94651),(0.96583, 0.93609, 0.94622),(0.96554, 0.93877, 0.94571),(0.96511, 0.9412, 0.94499),(0.96454, 0.9434, 0.94404),(0.96383, 0.94536, 0.94287),(0.96298, 0.9471, 0.94147),(0.96198, 0.94861, 0.93985),(0.96083, 0.94991, 0.93797),(0.95951, 0.95101, 0.93584),(0.95802, 0.95192, 0.93343),(0.95635, 0.95263, 0.93074),(0.95449, 0.95316, 0.92775),(0.95243, 0.9535, 0.92445),(0.95018, 0.95364, 0.92084),(0.94772, 0.9536, 0.91691),(0.94506, 0.95337, 0.91265),(0.94219, 0.95294, 0.90808),(0.93911, 0.95231, 0.90317),(0.93583, 0.9515, 0.89793),(0.93232, 0.95049, 0.89238),(0.92861, 0.94929, 0.8865),(0.92469, 0.9479, 0.8803),(0.92056, 0.94632, 0.87378),(0.91622, 0.94455, 0.86694),(0.91167, 0.94259, 0.8598),(0.90691, 0.94044, 0.85234),(0.90194, 0.93811, 0.84457),(0.89675, 0.9356, 0.8365),(0.89134, 0.93289, 0.82813),(0.88573, 0.93002, 0.81946),(0.87989, 0.92695, 0.81049),(0.87384, 0.92372, 0.80124),(0.86757, 0.92029, 0.79171),(0.86107, 0.91669, 0.7819),(0.85436, 0.9129, 0.77181),(0.84743, 0.90894, 0.76146),(0.84028, 0.9048, 0.75086),(0.8329, 0.90047, 0.74001),(0.82531, 0.89598, 0.72893),(0.81751, 0.8913, 0.71765),(0.8095, 0.88646, 0.70616),(0.80128, 0.88143, 0.69448),(0.79287, 0.87624, 0.68265),(0.78427, 0.87089, 0.67069),(0.77548, 0.86538, 0.65859),(0.76653, 0.85971, 0.6464),(0.75741, 0.85388, 0.63415),(0.74814, 0.84792, 0.62183),(0.73874, 0.84182, 0.6095),(0.7292, 0.83558, 0.59716),(0.71956, 0.82921, 0.58485),(0.70982, 0.82273, 0.57258),(0.69999, 0.81614, 0.56037),(0.69009, 0.80945, 0.54826),(0.68013, 0.80266, 0.53625),(0.67015, 0.79579, 0.52437),(0.66013, 0.78885, 0.51264),(0.6501, 0.78184, 0.50108),(0.64007, 0.77477, 0.48969),(0.63005, 0.76767, 0.47851),(0.62007, 0.76053, 0.46753),(0.61012, 0.75335, 0.45676),(0.60022, 0.74616, 0.44621),(0.59038, 0.73896, 0.4359),(0.58061, 0.73174, 0.42581),(0.57091, 0.72454, 0.41596),(0.5613, 0.71735, 0.40635),(0.55179, 0.71016, 0.39696),(0.54235, 0.703, 0.38782),(0.53302, 0.69587, 0.37891),(0.52379, 0.68877, 0.37022),(0.51467, 0.68169, 0.36177),(0.50563, 0.67467, 0.35351),(0.49672, 0.66769, 0.34547),(0.48792, 0.66074, 0.33764),(0.47922, 0.65385, 0.33),(0.47063, 0.64701, 0.32255),(0.46214, 0.64023, 0.31526),(0.45376, 0.63349, 0.30815),(0.44549, 0.62681, 0.3012),(0.43734, 0.62019, 0.29442),(0.42927, 0.61361, 0.28778),(0.4213, 0.60712, 0.28129),(0.41345, 0.60066, 0.27494),(0.4057, 0.59428, 0.26872),(0.39803, 0.58794, 0.2626),(0.39046, 0.58168, 0.2566),(0.383, 0.57548, 0.25072),(0.37561, 0.56932, 0.24493),(0.36833, 0.56324, 0.23926),(0.36112, 0.5572, 0.23365),(0.354, 0.55121, 0.22817),(0.34697, 0.54527, 0.22273),(0.33999, 0.53938, 0.21736),(0.33309, 0.53352, 0.21206),(0.3262, 0.5277, 0.20681),(0.3194, 0.52189, 0.20156),(0.3126, 0.51609, 0.19642),(0.30586, 0.51031, 0.19123),(0.2991, 0.50452, 0.18609),(0.29233, 0.4987, 0.18091),(0.28555, 0.49285, 0.17574),(0.27878, 0.48699, 0.17058),(0.27195, 0.48108, 0.16536),(0.26511, 0.47515, 0.16012),(0.25823, 0.46916, 0.15488),(0.25134, 0.4631, 0.14961),(0.24435, 0.45702, 0.14426),(0.23738, 0.45089, 0.13886),(0.2303, 0.44471, 0.13344),(0.22322, 0.43847, 0.12797),(0.21608, 0.43219, 0.12239),(0.20886, 0.42584, 0.11683),(0.20159, 0.41947, 0.11121),(0.19432, 0.41303, 0.10546),(0.18691, 0.40654, 0.099681),(0.17946, 0.4, 0.093826),(0.17194, 0.39342, 0.087904),(0.16436, 0.38679, 0.081888),(0.15666, 0.38012, 0.075659),(0.14884, 0.37339, 0.069479),(0.14097, 0.36663, 0.06304),(0.13291, 0.3598, 0.056434),(0.1247, 0.35294, 0.049637),(0.11638, 0.34602, 0.04255),(0.10778, 0.33909, 0.035407),(0.098981, 0.3321, 0.028358),(0.0899, 0.32505, 0.021963),(0.080424, 0.318, 0.016),(0.070529, 0.31091, 0.010244),(0.060124, 0.30378, 0.0051395),(0.049098, 0.29666, 0)]
            colo  = LinearSegmentedColormap.from_list('name',colors=colo,N=256)
        # -------------------------
        if self.colo == 'tokyo':
            # by www.fabiocrameri.ch/colourmaps
            from matplotlib.colors import LinearSegmentedColormap
            colo  = [(0.10387, 0.056805, 0.20243),(0.10975, 0.059104, 0.20564),(0.11566, 0.061046, 0.20884),(0.1216, 0.063055, 0.21209),(0.12757, 0.064935, 0.21531),(0.13351, 0.066895, 0.21858),(0.13939, 0.068939, 0.22184),(0.14535, 0.070894, 0.22512),(0.15119, 0.072938, 0.22845),(0.15708, 0.07497, 0.23177),(0.16298, 0.077038, 0.23511),(0.16886, 0.079188, 0.23844),(0.17475, 0.081435, 0.24182),(0.18061, 0.083639, 0.24519),(0.18652, 0.085843, 0.24863),(0.19242, 0.088221, 0.25206),(0.19833, 0.090586, 0.2555),(0.20429, 0.092949, 0.25898),(0.21021, 0.095479, 0.26246),(0.21619, 0.098018, 0.26598),(0.22212, 0.10056, 0.26951),(0.22812, 0.10325, 0.27306),(0.2341, 0.10596, 0.27664),(0.24009, 0.10871, 0.28021),(0.2461, 0.11159, 0.28383),(0.25214, 0.11445, 0.28745),(0.25815, 0.11746, 0.29112),(0.26421, 0.12052, 0.29477),(0.27026, 0.12365, 0.29845),(0.27631, 0.12687, 0.30215),(0.28236, 0.13021, 0.30588),(0.28839, 0.13354, 0.3096),(0.29442, 0.13697, 0.31333),(0.30046, 0.14049, 0.31707),(0.30651, 0.14408, 0.32083),(0.3125, 0.14775, 0.32457),(0.3185, 0.15147, 0.32834),(0.32447, 0.15529, 0.33211),(0.33042, 0.15918, 0.33586),(0.33634, 0.16315, 0.33963),(0.34223, 0.16717, 0.34337),(0.34808, 0.17124, 0.34711),(0.35387, 0.1754, 0.35084),(0.35963, 0.17962, 0.35455),(0.36533, 0.18389, 0.35824),(0.37097, 0.18825, 0.36192),(0.37657, 0.19261, 0.36557),(0.38208, 0.19706, 0.3692),(0.38753, 0.2015, 0.37279),(0.3929, 0.20606, 0.37638),(0.3982, 0.21059, 0.3799),(0.40342, 0.21518, 0.3834),(0.40854, 0.21982, 0.38685),(0.41357, 0.22443, 0.39027),(0.41851, 0.22913, 0.39364),(0.42335, 0.2338, 0.39696),(0.42811, 0.2385, 0.40025),(0.43275, 0.24322, 0.40348),(0.43729, 0.24796, 0.40666),(0.44172, 0.25267, 0.40979),(0.44603, 0.25739, 0.41286),(0.45026, 0.26211, 0.41587),(0.45436, 0.26682, 0.41882),(0.45835, 0.27152, 0.42172),(0.46223, 0.27624, 0.42457),(0.466, 0.28088, 0.42737),(0.46968, 0.28555, 0.43009),(0.47321, 0.29019, 0.43276),(0.47666, 0.29481, 0.43537),(0.48, 0.29942, 0.43793),(0.48321, 0.30398, 0.44041),(0.48633, 0.30854, 0.44286),(0.48934, 0.31305, 0.44524),(0.49226, 0.31754, 0.44756),(0.49507, 0.322, 0.44984),(0.49779, 0.32642, 0.45206),(0.5004, 0.33082, 0.45422),(0.50292, 0.33521, 0.45633),(0.50535, 0.33954, 0.45839),(0.50771, 0.34383, 0.4604),(0.50996, 0.34812, 0.46237),(0.51213, 0.35236, 0.46431),(0.51424, 0.35658, 0.46617),(0.51624, 0.36075, 0.468),(0.51819, 0.36491, 0.4698),(0.52005, 0.36904, 0.47155),(0.52185, 0.37313, 0.47324),(0.52359, 0.37721, 0.47493),(0.52526, 0.38125, 0.47656),(0.52687, 0.38525, 0.47815),(0.52841, 0.38925, 0.47973),(0.5299, 0.39321, 0.48125),(0.53134, 0.39714, 0.48276),(0.53273, 0.40107, 0.48423),(0.53406, 0.40495, 0.48567),(0.53535, 0.40883, 0.4871),(0.53661, 0.41269, 0.48849),(0.53781, 0.41652, 0.48985),(0.53897, 0.42033, 0.49121),(0.54009, 0.42412, 0.49252),(0.54118, 0.42791, 0.49383),(0.54224, 0.43167, 0.49511),(0.54326, 0.43542, 0.49637),(0.54425, 0.43914, 0.49763),(0.54522, 0.44286, 0.49885),(0.54616, 0.44657, 0.50006),(0.54706, 0.45026, 0.50126),(0.54795, 0.45394, 0.50244),(0.54882, 0.45761, 0.50361),(0.54965, 0.46127, 0.50477),(0.55048, 0.46492, 0.50591),(0.55128, 0.46856, 0.50705),(0.55207, 0.4722, 0.50818),(0.55283, 0.47583, 0.50929),(0.55358, 0.47945, 0.51039),(0.55433, 0.48306, 0.51148),(0.55505, 0.48667, 0.51257),(0.55576, 0.49027, 0.51365),(0.55646, 0.49387, 0.51472),(0.55716, 0.49747, 0.51578),(0.55783, 0.50106, 0.51684),(0.5585, 0.50465, 0.5179),(0.55917, 0.50823, 0.51895),(0.55983, 0.5118, 0.51997),(0.56047, 0.51538, 0.52102),(0.56111, 0.51897, 0.52204),(0.56175, 0.52253, 0.52308),(0.56239, 0.52611, 0.5241),(0.56301, 0.52969, 0.52511),(0.56363, 0.53325, 0.52613),(0.56425, 0.53684, 0.52714),(0.56485, 0.5404, 0.52815),(0.56546, 0.54398, 0.52916),(0.56608, 0.54755, 0.53016),(0.56669, 0.55112, 0.53116),(0.56729, 0.5547, 0.53216),(0.56789, 0.55827, 0.53315),(0.5685, 0.56186, 0.53414),(0.5691, 0.56543, 0.53513),(0.5697, 0.56901, 0.53612),(0.57031, 0.57261, 0.53711),(0.57092, 0.5762, 0.5381),(0.57153, 0.57978, 0.53908),(0.57214, 0.58337, 0.54006),(0.57276, 0.58696, 0.54104),(0.57337, 0.59056, 0.54202),(0.57399, 0.59417, 0.54301),(0.57461, 0.59778, 0.54399),(0.57524, 0.60139, 0.54497),(0.57589, 0.60501, 0.54596),(0.57653, 0.60864, 0.54694),(0.57717, 0.61225, 0.54792),(0.57782, 0.61589, 0.54891),(0.57849, 0.61954, 0.54989),(0.57918, 0.62318, 0.55087),(0.57987, 0.62683, 0.55187),(0.58056, 0.6305, 0.55286),(0.58127, 0.63417, 0.55385),(0.582, 0.63785, 0.55485),(0.58274, 0.64153, 0.55585),(0.5835, 0.64523, 0.55687),(0.58428, 0.64895, 0.55789),(0.58508, 0.65267, 0.55891),(0.5859, 0.65641, 0.55995),(0.58674, 0.66015, 0.56098),(0.5876, 0.66392, 0.56204),(0.5885, 0.6677, 0.5631),(0.58942, 0.67149, 0.56418),(0.59039, 0.67531, 0.56526),(0.59139, 0.67914, 0.56637),(0.59242, 0.683, 0.56749),(0.59349, 0.68688, 0.56863),(0.59461, 0.69078, 0.56979),(0.59578, 0.6947, 0.57097),(0.597, 0.69866, 0.57219),(0.59826, 0.70264, 0.57342),(0.5996, 0.70666, 0.57468),(0.60099, 0.7107, 0.57599),(0.60246, 0.71478, 0.57731),(0.604, 0.7189, 0.57868),(0.6056, 0.72305, 0.5801),(0.60731, 0.72725, 0.58155),(0.60909, 0.73148, 0.58305),(0.61097, 0.73576, 0.5846),(0.61294, 0.7401, 0.58621),(0.61503, 0.74447, 0.58787),(0.61723, 0.7489, 0.58959),(0.61955, 0.75338, 0.59139),(0.62198, 0.75792, 0.59325),(0.62456, 0.76251, 0.59518),(0.62727, 0.76716, 0.5972),(0.63013, 0.77187, 0.5993),(0.63314, 0.77664, 0.60148),(0.6363, 0.78146, 0.60376),(0.63963, 0.78635, 0.60611),(0.64313, 0.79129, 0.60859),(0.64681, 0.79629, 0.61116),(0.65067, 0.80136, 0.61382),(0.6547, 0.80648, 0.61662),(0.65894, 0.81164, 0.61951),(0.66337, 0.81686, 0.62251),(0.66798, 0.82213, 0.62564),(0.6728, 0.82743, 0.62888),(0.6778, 0.83276, 0.63223),(0.683, 0.83813, 0.6357),(0.68839, 0.84351, 0.63929),(0.69397, 0.84891, 0.64299),(0.69973, 0.85431, 0.64681),(0.70567, 0.85972, 0.65072),(0.71178, 0.86509, 0.65474),(0.71804, 0.87045, 0.65887),(0.72445, 0.87578, 0.66309),(0.731, 0.88106, 0.66739),(0.73768, 0.88628, 0.67178),(0.74447, 0.89143, 0.67624),(0.75136, 0.89651, 0.68075),(0.75833, 0.9015, 0.68534),(0.76537, 0.90639, 0.68996),(0.77246, 0.91117, 0.69462),(0.77959, 0.91583, 0.69932),(0.78675, 0.92037, 0.70404),(0.79392, 0.92477, 0.70878),(0.80108, 0.92904, 0.71351),(0.80822, 0.93317, 0.71825),(0.81534, 0.93716, 0.72297),(0.82241, 0.94098, 0.72768),(0.82944, 0.94466, 0.73237),(0.8364, 0.94818, 0.73701),(0.84329, 0.95154, 0.74163),(0.8501, 0.95476, 0.74621),(0.85683, 0.95782, 0.75075),(0.86348, 0.96072, 0.75524),(0.87002, 0.96348, 0.75967),(0.87648, 0.96609, 0.76406),(0.88284, 0.96857, 0.76839),(0.8891, 0.9709, 0.77268),(0.89526, 0.97311, 0.77691),(0.90133, 0.97518, 0.78108),(0.90729, 0.97714, 0.7852),(0.91316, 0.97898, 0.78927),(0.91894, 0.98071, 0.79329),(0.92463, 0.98234, 0.79725),(0.93023, 0.98386, 0.80117),(0.93575, 0.9853, 0.80504),(0.94119, 0.98664, 0.80888),(0.94656, 0.98791, 0.81266),(0.95185, 0.9891, 0.81642),(0.95708, 0.99022, 0.82012),(0.96225, 0.99128, 0.82381),(0.96736, 0.99228, 0.82746),(0.97242, 0.99323, 0.83108),(0.97743, 0.99412, 0.83468),(0.9824, 0.99498, 0.83825),(0.98733, 0.99579, 0.84181),(0.99222, 0.99658, 0.84535),(0.99708, 0.99733, 0.84887)]
            colo  = LinearSegmentedColormap.from_list('name',colors=colo,N=256)
        # -------------------------
        if self.colo == 'berlin':
            # by www.fabiocrameri.ch/colourmaps
            from matplotlib.colors import LinearSegmentedColormap
            colo  = [(0.62108, 0.69018, 0.99951),(0.61216, 0.68923, 0.99537),(0.6032, 0.68825, 0.99124),(0.5942, 0.68726, 0.98709),(0.58517, 0.68625, 0.98292),(0.57609, 0.68522, 0.97873),(0.56696, 0.68417, 0.97452),(0.55779, 0.6831, 0.97029),(0.54859, 0.68199, 0.96602),(0.53933, 0.68086, 0.9617),(0.53003, 0.67969, 0.95735),(0.52069, 0.67848, 0.95294),(0.51129, 0.67723, 0.94847),(0.50186, 0.67591, 0.94392),(0.49237, 0.67453, 0.9393),(0.48283, 0.67308, 0.93457),(0.47324, 0.67153, 0.92975),(0.46361, 0.6699, 0.92481),(0.45393, 0.66815, 0.91974),(0.44421, 0.66628, 0.91452),(0.43444, 0.66427, 0.90914),(0.42465, 0.66212, 0.90359),(0.41482, 0.65979, 0.89785),(0.40498, 0.65729, 0.89191),(0.39514, 0.65458, 0.88575),(0.3853, 0.65167, 0.87937),(0.37549, 0.64854, 0.87276),(0.36574, 0.64516, 0.8659),(0.35606, 0.64155, 0.8588),(0.34645, 0.63769, 0.85145),(0.33698, 0.63357, 0.84386),(0.32764, 0.62919, 0.83602),(0.31849, 0.62455, 0.82794),(0.30954, 0.61966, 0.81963),(0.30078, 0.6145, 0.81111),(0.29231, 0.60911, 0.80238),(0.2841, 0.60348, 0.79347),(0.27621, 0.59763, 0.78439),(0.26859, 0.59158, 0.77514),(0.26131, 0.58534, 0.76578),(0.25437, 0.57891, 0.7563),(0.24775, 0.57233, 0.74672),(0.24146, 0.5656, 0.73707),(0.23552, 0.55875, 0.72735),(0.22984, 0.5518, 0.7176),(0.2245, 0.54475, 0.7078),(0.21948, 0.53763, 0.698),(0.21469, 0.53043, 0.68819),(0.21017, 0.52319, 0.67838),(0.20589, 0.5159, 0.66858),(0.20177, 0.5086, 0.65879),(0.19788, 0.50126, 0.64903),(0.19417, 0.4939, 0.63929),(0.19056, 0.48654, 0.62957),(0.18711, 0.47918, 0.6199),(0.18375, 0.47183, 0.61024),(0.1805, 0.46447, 0.60062),(0.17737, 0.45712, 0.59104),(0.17426, 0.44979, 0.58148),(0.17122, 0.44247, 0.57197),(0.16824, 0.43517, 0.56249),(0.16529, 0.42788, 0.55302),(0.16244, 0.42061, 0.5436),(0.15954, 0.41337, 0.53421),(0.15674, 0.40615, 0.52486),(0.15391, 0.39893, 0.51552),(0.15112, 0.39176, 0.50623),(0.14835, 0.38459, 0.49697),(0.14564, 0.37746, 0.48775),(0.14288, 0.37034, 0.47854),(0.14014, 0.36326, 0.46939),(0.13747, 0.3562, 0.46024),(0.13478, 0.34916, 0.45115),(0.13208, 0.34215, 0.44209),(0.1294, 0.33517, 0.43304),(0.12674, 0.3282, 0.42404),(0.12409, 0.32126, 0.41507),(0.12146, 0.31435, 0.40614),(0.1189, 0.30746, 0.39723),(0.11632, 0.30061, 0.38838),(0.11373, 0.29378, 0.37955),(0.11119, 0.28698, 0.37075),(0.10861, 0.28022, 0.362),(0.10616, 0.2735, 0.35328),(0.10367, 0.26678, 0.34459),(0.10118, 0.26011, 0.33595),(0.098776, 0.25347, 0.32734),(0.096347, 0.24685, 0.31878),(0.094059, 0.24026, 0.31027),(0.091788, 0.23373, 0.30176),(0.089506, 0.22725, 0.29332),(0.087341, 0.2208, 0.28491),(0.085142, 0.21436, 0.27658),(0.083069, 0.20798, 0.26825),(0.081098, 0.20163, 0.25999),(0.07913, 0.19536, 0.25178),(0.077286, 0.18914, 0.24359),(0.075571, 0.18294, 0.2355),(0.073993, 0.17683, 0.22743),(0.07241, 0.17079, 0.21943),(0.071045, 0.1648, 0.2115),(0.069767, 0.1589, 0.20363),(0.068618, 0.15304, 0.19582),(0.06756, 0.14732, 0.18812),(0.066665, 0.14167, 0.18045),(0.065923, 0.13608, 0.17292),(0.065339, 0.1307, 0.16546),(0.064911, 0.12535, 0.15817),(0.064636, 0.12013, 0.15095),(0.064517, 0.11507, 0.14389),(0.064554, 0.11022, 0.13696),(0.064749, 0.10543, 0.13023),(0.0651, 0.10085, 0.12357),(0.065383, 0.096469, 0.11717),(0.065574, 0.092338, 0.11101),(0.065892, 0.088201, 0.10498),(0.066388, 0.084134, 0.099288),(0.067108, 0.080051, 0.093829),(0.068193, 0.076099, 0.08847),(0.06972, 0.072283, 0.083025),(0.071639, 0.068654, 0.077544),(0.073978, 0.065058, 0.07211),(0.076596, 0.061657, 0.066651),(0.079637, 0.05855, 0.061133),(0.082963, 0.055666, 0.055745),(0.086537, 0.052997, 0.050336),(0.090315, 0.050699, 0.04504),(0.09426, 0.048753, 0.039773),(0.098319, 0.047041, 0.034683),(0.10246, 0.045624, 0.030074),(0.10673, 0.044705, 0.026012),(0.11099, 0.043972, 0.022379),(0.11524, 0.043596, 0.01915),(0.11955, 0.043567, 0.016299),(0.12381, 0.043861, 0.013797),(0.1281, 0.044459, 0.011588),(0.13232, 0.045229, 0.0095315),(0.13645, 0.046164, 0.0078947),(0.14063, 0.047374, 0.006502),(0.14488, 0.048634, 0.0053266),(0.14923, 0.049836, 0.0043455),(0.15369, 0.050997, 0.0035374),(0.15831, 0.05213, 0.0028824),(0.16301, 0.053218, 0.0023628),(0.16781, 0.05424, 0.0019629),(0.17274, 0.055172, 0.001669),(0.1778, 0.056018, 0.0014692),(0.18286, 0.05682, 0.0013401),(0.18806, 0.057574, 0.0012617),(0.19323, 0.058514, 0.0012261),(0.19846, 0.05955, 0.0012271),(0.20378, 0.060501, 0.0012601),(0.20909, 0.061486, 0.0013221),(0.21447, 0.06271, 0.0014116),(0.2199, 0.063823, 0.0015287),(0.22535, 0.065027, 0.0016748),(0.23086, 0.066297, 0.0018529),(0.23642, 0.067645, 0.0020675),(0.24202, 0.069092, 0.0023247),(0.24768, 0.070458, 0.0026319),(0.25339, 0.071986, 0.0029984),(0.25918, 0.07364, 0.003435),(0.265, 0.075237, 0.0039545),(0.27093, 0.076965, 0.004571),(0.27693, 0.078822, 0.0053006),(0.28302, 0.080819, 0.0061608),(0.2892, 0.082879, 0.0071713),(0.29547, 0.085075, 0.0083494),(0.30186, 0.08746, 0.0097258),(0.30839, 0.089912, 0.011455),(0.31502, 0.09253, 0.013324),(0.32181, 0.095392, 0.015413),(0.32874, 0.098396, 0.01778),(0.3358, 0.10158, 0.020449),(0.34304, 0.10498, 0.02344),(0.35041, 0.10864, 0.026771),(0.35795, 0.11256, 0.030456),(0.36563, 0.11666, 0.034571),(0.37347, 0.12097, 0.039115),(0.38146, 0.12561, 0.043693),(0.38958, 0.13046, 0.048471),(0.39785, 0.13547, 0.053136),(0.40622, 0.1408, 0.057848),(0.41469, 0.14627, 0.062715),(0.42323, 0.15198, 0.067685),(0.43184, 0.15791, 0.073044),(0.44044, 0.16403, 0.07862),(0.44909, 0.17027, 0.084644),(0.4577, 0.17667, 0.090869),(0.46631, 0.18321, 0.097335),(0.4749, 0.18989, 0.10406),(0.48342, 0.19668, 0.11104),(0.49191, 0.20352, 0.11819),(0.50032, 0.21043, 0.1255),(0.50869, 0.21742, 0.13298),(0.51698, 0.22443, 0.14062),(0.5252, 0.23154, 0.14835),(0.53335, 0.23862, 0.15626),(0.54144, 0.24575, 0.16423),(0.54948, 0.25292, 0.17226),(0.55746, 0.26009, 0.1804),(0.56538, 0.26726, 0.18864),(0.57327, 0.27446, 0.19692),(0.58111, 0.28167, 0.20524),(0.58892, 0.28889, 0.21362),(0.59672, 0.29611, 0.22205),(0.60448, 0.30335, 0.23053),(0.61223, 0.31062, 0.23905),(0.61998, 0.31787, 0.24762),(0.62771, 0.32513, 0.25619),(0.63544, 0.33244, 0.26481),(0.64317, 0.33975, 0.27349),(0.65092, 0.34706, 0.28218),(0.65866, 0.3544, 0.29089),(0.66642, 0.36175, 0.29964),(0.67419, 0.36912, 0.30842),(0.68198, 0.37652, 0.31722),(0.68978, 0.38392, 0.32604),(0.6976, 0.39135, 0.33493),(0.70543, 0.39879, 0.3438),(0.71329, 0.40627, 0.35272),(0.72116, 0.41376, 0.36166),(0.72905, 0.42126, 0.37062),(0.73697, 0.4288, 0.37962),(0.7449, 0.43635, 0.38864),(0.75285, 0.44392, 0.39768),(0.76083, 0.45151, 0.40675),(0.76882, 0.45912, 0.41584),(0.77684, 0.46676, 0.42496),(0.78488, 0.47441, 0.43409),(0.79293, 0.48208, 0.44327),(0.80101, 0.48976, 0.45246),(0.80911, 0.49749, 0.46167),(0.81722, 0.50521, 0.47091),(0.82536, 0.51296, 0.48017),(0.83352, 0.52073, 0.48945),(0.84169, 0.52853, 0.49876),(0.84988, 0.53634, 0.5081),(0.85809, 0.54416, 0.51745),(0.86632, 0.55201, 0.52683),(0.87457, 0.55988, 0.53622),(0.88283, 0.56776, 0.54564),(0.89111, 0.57567, 0.55508),(0.89941, 0.58358, 0.56455),(0.90772, 0.59153, 0.57404),(0.91603, 0.59949, 0.58355),(0.92437, 0.60747, 0.59309),(0.93271, 0.61546, 0.60265),(0.94108, 0.62348, 0.61223),(0.94945, 0.63151, 0.62183),(0.95783, 0.63956, 0.63147),(0.96622, 0.64763, 0.64111),(0.97462, 0.65572, 0.65079),(0.98303, 0.66382, 0.66049),(0.99145, 0.67194, 0.67022),(0.99987, 0.68007, 0.67995)]
            colo  = LinearSegmentedColormap.from_list('name',colors=colo,N=256)
        # -------------------------
        if self.colo == 'batlow':
            # by www.fabiocrameri.ch/colourmaps
            from matplotlib.colors import LinearSegmentedColormap
            colo  = [(0.0051932, 0.098238, 0.34984),(0.0090652, 0.10449, 0.35093),(0.012963, 0.11078, 0.35199),(0.01653, 0.11691, 0.35307),(0.019936, 0.12298, 0.35412),(0.023189, 0.12904, 0.35518),(0.026291, 0.13504, 0.35621),(0.029245, 0.14096, 0.35724),(0.032053, 0.14677, 0.35824),(0.034853, 0.15256, 0.35923),(0.037449, 0.15831, 0.36022),(0.039845, 0.16398, 0.36119),(0.042104, 0.16956, 0.36215),(0.044069, 0.17505, 0.36308),(0.045905, 0.18046, 0.36401),(0.047665, 0.18584, 0.36491),(0.049378, 0.19108, 0.36581),(0.050795, 0.19627, 0.36668),(0.052164, 0.20132, 0.36752),(0.053471, 0.20636, 0.36837),(0.054721, 0.21123, 0.36918),(0.055928, 0.21605, 0.36997),(0.057033, 0.22075, 0.37075),(0.058032, 0.22534, 0.37151),(0.059164, 0.22984, 0.37225),(0.060167, 0.2343, 0.37298),(0.061052, 0.23862, 0.37369),(0.06206, 0.24289, 0.37439),(0.063071, 0.24709, 0.37505),(0.063982, 0.25121, 0.37571),(0.064936, 0.25526, 0.37636),(0.065903, 0.25926, 0.37699),(0.066899, 0.26319, 0.37759),(0.067921, 0.26706, 0.37819),(0.069002, 0.27092, 0.37877),(0.070001, 0.27471, 0.37934),(0.071115, 0.2785, 0.37989),(0.072192, 0.28225, 0.38043),(0.07344, 0.28594, 0.38096),(0.074595, 0.28965, 0.38145),(0.075833, 0.29332, 0.38192),(0.077136, 0.297, 0.38238),(0.078517, 0.30062, 0.38281),(0.079984, 0.30425, 0.38322),(0.081553, 0.30786, 0.3836),(0.083082, 0.31146, 0.38394),(0.084778, 0.31504, 0.38424),(0.086503, 0.31862, 0.38451),(0.088353, 0.32217, 0.38473),(0.090281, 0.32569, 0.38491),(0.092304, 0.32922, 0.38504),(0.094462, 0.33271, 0.38512),(0.096618, 0.33616, 0.38513),(0.099015, 0.33962, 0.38509),(0.10148, 0.34304, 0.38498),(0.10408, 0.34641, 0.3848),(0.10684, 0.34977, 0.38455),(0.1097, 0.3531, 0.38422),(0.11265, 0.35639, 0.38381),(0.11575, 0.35964, 0.38331),(0.11899, 0.36285, 0.38271),(0.12232, 0.36603, 0.38203),(0.12589, 0.36916, 0.38126),(0.12952, 0.37224, 0.38038),(0.1333, 0.37528, 0.3794),(0.13721, 0.37828, 0.37831),(0.14126, 0.38124, 0.37713),(0.14543, 0.38413, 0.37584),(0.14971, 0.38698, 0.37445),(0.15407, 0.38978, 0.37293),(0.15862, 0.39253, 0.37132),(0.16325, 0.39524, 0.36961),(0.16795, 0.39789, 0.36778),(0.17279, 0.4005, 0.36587),(0.17775, 0.40304, 0.36383),(0.18273, 0.40555, 0.36171),(0.18789, 0.408, 0.35948),(0.19305, 0.41043, 0.35718),(0.19831, 0.4128, 0.35477),(0.20368, 0.41512, 0.35225),(0.20908, 0.41741, 0.34968),(0.21455, 0.41966, 0.34702),(0.22011, 0.42186, 0.34426),(0.22571, 0.42405, 0.34146),(0.23136, 0.4262, 0.33857),(0.23707, 0.42832, 0.33563),(0.24279, 0.43042, 0.33263),(0.24862, 0.43249, 0.32957),(0.25445, 0.43453, 0.32643),(0.26032, 0.43656, 0.32329),(0.26624, 0.43856, 0.32009),(0.27217, 0.44054, 0.31683),(0.27817, 0.44252, 0.31355),(0.28417, 0.44448, 0.31024),(0.29021, 0.44642, 0.30689),(0.29629, 0.44836, 0.30351),(0.30238, 0.45028, 0.30012),(0.30852, 0.4522, 0.29672),(0.31465, 0.45411, 0.29328),(0.32083, 0.45601, 0.28984),(0.32701, 0.4579, 0.28638),(0.33323, 0.45979, 0.28294),(0.33947, 0.46168, 0.27947),(0.3457, 0.46356, 0.276),(0.35198, 0.46544, 0.27249),(0.35828, 0.46733, 0.26904),(0.36459, 0.46921, 0.26554),(0.37092, 0.47109, 0.26206),(0.37729, 0.47295, 0.25859),(0.38368, 0.47484, 0.25513),(0.39007, 0.47671, 0.25166),(0.3965, 0.47859, 0.24821),(0.40297, 0.48047, 0.24473),(0.40945, 0.48235, 0.24131),(0.41597, 0.48423, 0.23789),(0.42251, 0.48611, 0.23449),(0.42909, 0.48801, 0.2311),(0.43571, 0.48989, 0.22773),(0.44237, 0.4918, 0.22435),(0.44905, 0.49368, 0.22107),(0.45577, 0.49558, 0.21777),(0.46254, 0.4975, 0.21452),(0.46937, 0.49939, 0.21132),(0.47622, 0.50131, 0.20815),(0.48312, 0.50322, 0.20504),(0.49008, 0.50514, 0.20198),(0.49709, 0.50706, 0.19899),(0.50415, 0.50898, 0.19612),(0.51125, 0.5109, 0.1933),(0.51842, 0.51282, 0.19057),(0.52564, 0.51475, 0.18799),(0.53291, 0.51666, 0.1855),(0.54023, 0.51858, 0.1831),(0.5476, 0.52049, 0.18088),(0.55502, 0.52239, 0.17885),(0.56251, 0.52429, 0.17696),(0.57002, 0.52619, 0.17527),(0.57758, 0.52806, 0.17377),(0.5852, 0.52993, 0.17249),(0.59285, 0.53178, 0.17145),(0.60052, 0.5336, 0.17065),(0.60824, 0.53542, 0.1701),(0.61597, 0.53723, 0.16983),(0.62374, 0.539, 0.16981),(0.63151, 0.54075, 0.17007),(0.6393, 0.54248, 0.17062),(0.6471, 0.54418, 0.17146),(0.65489, 0.54586, 0.1726),(0.66269, 0.5475, 0.17404),(0.67048, 0.54913, 0.17575),(0.67824, 0.55071, 0.1778),(0.686, 0.55227, 0.18006),(0.69372, 0.5538, 0.18261),(0.70142, 0.55529, 0.18548),(0.7091, 0.55677, 0.18855),(0.71673, 0.5582, 0.19185),(0.72432, 0.55963, 0.19541),(0.73188, 0.56101, 0.19917),(0.73939, 0.56239, 0.20318),(0.74685, 0.56373, 0.20737),(0.75427, 0.56503, 0.21176),(0.76163, 0.56634, 0.21632),(0.76894, 0.56763, 0.22105),(0.77621, 0.5689, 0.22593),(0.78342, 0.57016, 0.23096),(0.79057, 0.57142, 0.23616),(0.79767, 0.57268, 0.24149),(0.80471, 0.57393, 0.24696),(0.81169, 0.57519, 0.25257),(0.81861, 0.57646, 0.2583),(0.82547, 0.57773, 0.2642),(0.83227, 0.57903, 0.27021),(0.839, 0.58034, 0.27635),(0.84566, 0.58167, 0.28263),(0.85225, 0.58304, 0.28904),(0.85875, 0.58444, 0.29557),(0.86517, 0.58588, 0.30225),(0.87151, 0.58735, 0.30911),(0.87774, 0.58887, 0.31608),(0.88388, 0.59045, 0.32319),(0.8899, 0.59209, 0.33045),(0.89581, 0.59377, 0.33787),(0.90159, 0.59551, 0.34543),(0.90724, 0.59732, 0.35314),(0.91275, 0.59919, 0.36099),(0.9181, 0.60113, 0.369),(0.9233, 0.60314, 0.37714),(0.92832, 0.60521, 0.3854),(0.93318, 0.60737, 0.39382),(0.93785, 0.60958, 0.40235),(0.94233, 0.61187, 0.41101),(0.94661, 0.61422, 0.41977),(0.9507, 0.61665, 0.42862),(0.95457, 0.61914, 0.43758),(0.95824, 0.62167, 0.4466),(0.9617, 0.62428, 0.4557),(0.96494, 0.62693, 0.46486),(0.96798, 0.62964, 0.47406),(0.9708, 0.63239, 0.48329),(0.97342, 0.63518, 0.49255),(0.97584, 0.63801, 0.50183),(0.97805, 0.64087, 0.51109),(0.98008, 0.64375, 0.52035),(0.98192, 0.64666, 0.5296),(0.98357, 0.64959, 0.53882),(0.98507, 0.65252, 0.548),(0.98639, 0.65547, 0.55714),(0.98757, 0.65842, 0.56623),(0.9886, 0.66138, 0.57526),(0.9895, 0.66433, 0.58425),(0.99027, 0.66728, 0.59317),(0.99093, 0.67023, 0.60203),(0.99148, 0.67316, 0.61084),(0.99194, 0.67609, 0.61958),(0.9923, 0.67901, 0.62825),(0.99259, 0.68191, 0.63687),(0.99281, 0.68482, 0.64542),(0.99297, 0.68771, 0.65393),(0.99306, 0.69058, 0.6624),(0.99311, 0.69345, 0.67081),(0.99311, 0.69631, 0.67918),(0.99307, 0.69916, 0.68752),(0.993, 0.70201, 0.69583),(0.9929, 0.70485, 0.70411),(0.99277, 0.70769, 0.71238),(0.99262, 0.71053, 0.72064),(0.99245, 0.71337, 0.72889),(0.99226, 0.71621, 0.73715),(0.99205, 0.71905, 0.7454),(0.99184, 0.72189, 0.75367),(0.99161, 0.72475, 0.76196),(0.99137, 0.72761, 0.77027),(0.99112, 0.73049, 0.77861),(0.99086, 0.73337, 0.78698),(0.99059, 0.73626, 0.79537),(0.99031, 0.73918, 0.80381),(0.99002, 0.7421, 0.81229),(0.98972, 0.74504, 0.8208),(0.98941, 0.748, 0.82937),(0.98909, 0.75097, 0.83798),(0.98875, 0.75395, 0.84663),(0.98841, 0.75695, 0.85533),(0.98805, 0.75996, 0.86408),(0.98767, 0.763, 0.87286),(0.98728, 0.76605, 0.8817),(0.98687, 0.7691, 0.89057),(0.98643, 0.77218, 0.89949),(0.98598, 0.77527, 0.90845),(0.9855, 0.77838, 0.91744),(0.985, 0.7815, 0.92647),(0.98447, 0.78462, 0.93553),(0.98391, 0.78776, 0.94463),(0.98332, 0.79091, 0.95375),(0.9827, 0.79407, 0.9629),(0.98205, 0.79723, 0.97207),(0.98135, 0.80041, 0.98127)]
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
