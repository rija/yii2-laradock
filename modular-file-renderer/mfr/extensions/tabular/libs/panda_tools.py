from tempfile import NamedTemporaryFile

import numpy
import pandas

from mfr.extensions.tabular.utilities import header_population, strip_comments, sav_to_csv


def csv_pandas(fp):
    """Read and convert a csv file to JSON format using the pandas library
    :param fp: File pointer object
    :return: tuple of table headers and data
    """
    with NamedTemporaryFile(mode='w+b') as temp:
        strip_comments(fp, temp)
        dataframe = pandas.read_csv(temp.name)
    return data_from_dataframe(dataframe)


def tsv_pandas(fp):
    """Read and convert a tsv file to JSON format using the pandas library
    :param fp: File pointer object
    :return: tuple of table headers and data
    """
    with NamedTemporaryFile(mode='w+b') as temp:
        strip_comments(fp, temp)
        dataframe = pandas.read_csv(temp.name, sep='\t')
    return data_from_dataframe(dataframe)


def dta_pandas(fp):
    """Read and convert a dta file to JSON format using the pandas library
    :param fp: File pointer object
    :return: tuple of table headers and data
    """
    dataframe = pandas.read_stata(fp)
    return data_from_dataframe(dataframe)


def sav_pandas(fp):
    """Read and convert a .sav file to a .csv file via pspp, then convert that to JSON format
    using the pandas library

    :param fp: File pointer object
    :return: tuple of table headers and data
    """
    csv_file = sav_to_csv(fp)
    dataframe = pandas.read_csv(csv_file.name, low_memory=False)
    return data_from_dataframe(dataframe)


def data_from_dataframe(dataframe):
    """Convert a dataframe object to a list of dictionaries
    :param fp: File pointer object
    :return: tuple of table headers and data
    """

    fields = dataframe.keys()
    header = header_population(fields)
    # iterate over the dataframe using `numpy.asscalar` to ensure we have native
    # python types, this prevents issues with serialization later on.
    data = []
    for _, frame_row in dataframe.iterrows():
        data_row = {}
        for name, value in frame_row.iteritems():
            try:
                data_row[name] = numpy.asscalar(value)
            except AttributeError:
                data_row[name] = value
        data.append(data_row)
    return {'Sheet 1': (header, data)}
