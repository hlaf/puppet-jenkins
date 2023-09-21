define jenkins::label(
  $ensure = present,
  $value  = $title,
) {
  validate_string($value)

  if $::operatingsystem != 'windows' {
    include ::jenkins::slave
  }

  if $ensure == 'present' {
    concat::fragment { "${value}@jenkins::label":
      target  => 'JENKINS_LABELS_FILE',
      content => $::operatingsystem ? {
        'windows' => "${value} ",
        default   => $value,
      },
    }
  }

}
