define jenkins::label(
  $ensure = present,
  $value  = $title,
) {
  validate_string($value)

  include ::jenkins::slave

  if $ensure == 'present' {
    concat::fragment { "${value}@jenkins::label":
      target  => 'JENKINS_LABELS_FILE',
      content => $value,
    }
  }

}
