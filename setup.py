#!/usr/bin/env python

from setuptools import setup

setup(name='vcseedftp',
    version='0.1.0',
    description='',
    author='Mat Lee, Dieter Hsu',
    author_email='matlinuxer2@gmail.com, dieterplex@gmail.com',
    url='https://bitbucket.org/matlinuxer2/vcseedftp',
    license='',
    scripts=['vcseedftp'],
    data_files=[('/etc/', ['vcseedftp.ini.tmpl'])],
    install_requires=['psutil'],
)
