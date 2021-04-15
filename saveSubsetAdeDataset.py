import pandas as pd
import pylab as P
import numpy as np

def main(local): 
	#Load datasets of relevance
	MissingIndex = pd.read_csv('../masks-ade-4/AtrFileIndexError_20210413-200239.csv', header = None,names = ['category','filepath'])
	SegMissing = pd.read_csv('../masks-ade-4/SegMasksNotFound_20210413-200239.csv')
	if local:
		Ade_subset = pd.read_csv('../ADE20K_labels/Ade20K_labels_local.txt').set_index('filename')
	else:
		Ade_subset = pd.read_csv('../ADE20K_labels/Ade20K_labels_marcc.txt').set_index('filename')
	MissingIndex['Filenames'] = [i[-1] for i in MissingIndex.filepath.str.split('/')]
	SegMissing['Filenames'] = [i[-1] for i in SegMissing.filepath.str.split('/')]
	MissingIndex = MissingIndex.set_index('Filenames')
	SegMissing = SegMissing.set_index('Filenames')
	#Drop non index rows
	Ade_subset = Ade_subset.drop(MissingIndex.index, axis=0)
	Ade_subset = Ade_subset.drop(SegMissing.index, axis=0)
	Ade_subset.reset_index(inplace=True)
	Ade_subset = Ade_subset[['condition', 'object', 'filepath', 'filename']]
	if local:
		Ade_subset.to_csv('../ADE20K_labels/Ade20K_labels_local_subset.txt')
	else:
		Ade_subset.to_csv('../ADE20K_labels/Ade20K_labels_marcc_subset.txt')


#Compute aggregate statistics to see percent of missing index objects, and plot it
def plotPercentMissing():
	missindex_pd = pd.DataFrame({'countNoIndex' : MissingIndex.groupby('category').filepath.count()})
	AdeCount_pd = pd.DataFrame({'count' : Ade_subset.groupby('object').filepath.count()})
	Combinedf = missindex_pd.merge(AdeCount_pd, left_index=True, right_index=True)
	percentAffected = Combinedf['countNoIndex']/Combinedf['count']
	P.figure(figsize=(8, 6), dpi=80)
	bp = P.boxplot(percentAffected)
	y = percentAffected
	x = np.random.normal(1, 0.04, size=len(y))
	P.plot(x, y, 'r.', alpha=0.2)
	P.show()


if __name__ == "__main__":
	local = 1
	main(local)


