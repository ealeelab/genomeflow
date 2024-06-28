from setuptools import setup, find_packages

setup(
    name='genomeflow',
    version='0.1.0',
    author='Junseok Park',
    author_email='junseok.park@childrens.harvard.edu',
    description='A Python package for genome data processing and analysis.',
    long_description=open('README.md').read(),
    long_description_content_type='text/markdown',
    url='https://github.com/aleelab/genomeflow',
    packages=find_packages(),
    classifiers=[
        'Programming Language :: Python :: 3',
        'License :: OSI Approved :: MIT License',
        'Operating System :: OS Independent',
    ],
    python_requires='>=3.6',
    install_requires=[
        'numpy',
        'pandas',
        # Add other dependencies here
    ],
    entry_points={
        'console_scripts': [
            'genomeflow=genomeflow.__main__:main',
        ],
    },
)
