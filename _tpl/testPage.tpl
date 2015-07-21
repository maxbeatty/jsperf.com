<?php

if (!empty($_POST)) {
	include('_act/postComment.tpl');
}

class Swap {
	public static $items = array();

	public static function tagsToTokens($tag) {
		// add highlighted script bodies
		array_unshift(Swap::$items, preg_replace('/&nbsp;$/', '', highlight($tag[2])));
		return $tag[1] . '@jsPerfTagToken' . $tag[3];
	}

	public static function tokensToTags() {
		return array_pop(Swap::$items);
	}
}

$reScripts = '#(<script[^>]*?>)([\s\S]*?)(</script>)#i';
$reTokens = '/@jsPerfTagToken/';

// initHTML with script tags stripped out
$stripped = preg_replace($reScripts, '', $item->initHTML);
preg_match_all($reScripts, $item->initHTML, $scripts);

// an array of script tags
$item->scripts = array_shift($scripts);
if (!is_array($item->scripts)) {
  $item->scripts = array();
}

// swap script bodies with tokens
$highlighted = preg_replace_callback($reScripts, 'Swap::tagsToTokens', $item->initHTML);
// highlight the html
$highlighted = highlight($highlighted, 'html');
// swap tokens with highlighted script bodies
$highlighted = preg_replace_callback($reTokens, 'Swap::tokensToTags', $highlighted);

echo $highlighted;
