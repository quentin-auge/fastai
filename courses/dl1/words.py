import pandas as pd
import os
import glob


def get_language(filepath):
    filename = os.path.basename(filepath)
    language = filename.split('_')[0]
    return language


def get_filepaths(*languages):
    languages = tuple(languages)
    filepaths = glob.glob('data/words/*_*-words.txt')
    filepaths = [f for f in filepaths if get_language(f).startswith(languages)]
    return filepaths


def get_ncols(filepath):
    df = pd.read_csv(filepath, delim_whitespace=True, nrows=0)
    ncols = len(df.columns)
    return ncols


def read_data(filepaths):
    dfs = []
    for filepath in filepaths:
        ncols = get_ncols(filepath)
        df = pd.read_csv(filepath, sep='\t', usecols=[0, 1, ncols-1], index_col=0,
                         names=['idx', 'word', 'freq'], quoting=3)
        df['language'] = get_language(filepath)
        dfs.append(df)
    df = pd.concat(dfs)
    df = df.reset_index(drop=True)
    return df


def filter_data(df, min_len, max_len, min_freq):
    df = df[~df.word.isnull()]
    df = df[df.freq.astype(int) >= min_freq]
    df['word'] = df.word.str.normalize('NFKD').str.encode('ascii', errors='ignore').str.decode('utf-8')
    df['word'] = df.word.str.lower()
    regex = '^[a-z]{%i,%i}$' % (min_len, max_len)
    df = df[df.word.str.match(regex)]
    return df


def extract_features(df):

    feats = df.word.apply(lambda x: pd.Series(list(x)))
    feats['language'] = df.language

    for col in feats.columns:
        feats[col] = feats[col].astype('category').cat.as_ordered()

    return feats


if __name__ == '__main__':

    MAX_LEN = 15

    filepaths = get_filepaths('en', 'de', 'fr', 'it', 'sp')
    df = read_data(filepaths)

    df = filter_data(df, min_len=4, max_len=MAX_LEN, min_freq=5)
    feats = extract_features(df)

    print(df)
    print(feats)
