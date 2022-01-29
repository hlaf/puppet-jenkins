define jenkins::label(
  $ensure = present,
  $value  = $title,
) {
  validate_string($value)

  include ::jenkins::slave

  concat::fragment { "${value}@jenkins::label":
    target  => 'JENKINS_LABELS_FILE',
    content => $value,
  }

}
