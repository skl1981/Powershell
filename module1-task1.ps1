$table1 = @{a = 1; c = 3; r = 6; d = 7}
$Table2 = @{c = 3; b = 4; d = 7; s = 9}
foreach ($n in $table1.keys)
{ if ($table2.ContainsKey($n))
  { $table2.Remove($n)  }
}
$result = $table1 + $table2
$result.GetEnumerator() | Sort-Object -Property Name