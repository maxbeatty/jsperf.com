<?php

// http://crbug.com/85454
if (isset($item)) {
	header('X-XSS-Protection: 0');
}

?>
<html lang="en"<?php if ($embed) { ?> class="embed"<?php } ?>>

<title><?php if (isset($title)) { ?><?php echo removeBackticks(he($title)); ?> · jsPerf<?php } ?></title>

<?php if ($showAtom && isset($item) && '' !== trim($item->info)) { ?>
<meta name="description" content="<?php echo trim(shorten(strip_tags(str_replace(array('"', "\n"), array('&quot;', ' '), md($item->info))))); ?>">

<?php } else if ($noIndex) { ?>
<meta name="robots" content="noindex">
<meta name="referrer" content="origin">

<?php } ?>


<?php if ($author) { ?>
<link href="/browse/<?php echo $author; ?>.atom" rel="alternate" type="application/atom+xml" title="Atom feed for test cases by this author">

<?php } else if ($search) { ?>
<link href="/search.atom?q=<?php echo urlencode($search); ?>" rel="alternate" type="application/atom+xml" title="Atom feed for test cases about <?php echo he($search); ?>">

<?php } else if ($showAtom) { ?>
<link href="/<?php echo $slug; ?>.atom" rel="alternate" type="application/atom+xml" title="<?php echo ($slug == 'browse' ? 'Atom feed for new or updated test cases' : 'Atom feed for revisions of this test case'); ?>">

<?php } ?>

<?php flush(); ?>
