<?php $db->close(); ?>

<?php if ($benchmark) {
  <script>
    <?php if ($item->browserscopeID) { ?>
      ui.browserscope.key = '<?php echo $item->browserscopeID; ?>';

    <?php } ?>

    ui<?php foreach ($tests as $index => $test) {
      echo $index ? ")\n  " : '';
      ?>
    .add(
      '<?php echo etago(addslashes(removeBackticks($test->title))); ?>',
      <?php if ('y' == $test->defer) { ?>
        {
          'defer': true,
          'fn': <?php echo "'\\\n      " . preg_replace('/[\r\n]{1,2}/', "\\n\\\n      ", etago(addslashes($test->code))) . "'\n" ?>
        }
      <?php } else { ?>
        '<?php echo "\\\n    " . preg_replace('/[\r\n]{1,2}/', "\\n\\\n    ", etago(addslashes($test->code))); ?>'<?php echo "\n  ";
      }
    }
    ?>);

    <?php
      echo ($item->setup ? "\n  Benchmark.prototype.setup = '\\\n    " . preg_replace('/[\r\n]{1,2}/', "\\n\\\n    ", etago(addslashes($item->setup))) . "';\n" : '');
      echo ($item->teardown ? "\n  Benchmark.prototype.teardown = '\\\n    " . preg_replace('/[\r\n]{1,2}/', "\\n\\\n    ", etago(addslashes($item->teardown))) . "';\n" : '')
    ?>
  </script>

  <?php
    if (isset($item->scripts)) {
      echo "\n" . implode("\n", $item->scripts) . (count($item->scripts) ? "\n" : '');
    }
} else if ($mainJS) { ?>
  <?php flush(); ?>
