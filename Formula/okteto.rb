class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://github.com/okteto/okteto/archive/1.8.21.tar.gz"
  sha256 "10392ac98fe9d3ec18714b7fe1b1320a16f604820fc948f863a9c361d0804dd6"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "918d0f74f183234e2c1f63440f9f8efaa8b9bbdedce74fa0fbfc06595af01c8b" => :catalina
    sha256 "122e03f21a2a2e44c1aa24e10203617870310d74e6a7072867cb8fe8bcc6348f" => :mojave
    sha256 "db832e9937d0d15bf5e286f53f76106a32f250bf76ec84e47b280510e379dd7d" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/okteto/okteto/pkg/config.VersionString=#{version}"
    tags = "osusergo netgo static_build"
    system "go", "build", "-o", "#{bin}/#{name}", "-trimpath", "-ldflags", ldflags, "-tags", tags
  end

  test do
    touch "test.rb"
    system "echo | okteto init --overwrite --file test.yml"
    expected = <<~EOS
      name: #{Pathname.getwd.basename}
      image: okteto/ruby:2
      command:
      - bash
      workdir: /okteto
      sync:
      - .:/okteto
      forward:
      - 1234:1234
      - 8080:8080
      persistentVolume: {}
    EOS
    got = File.read("test.yml")
    assert_equal expected, got
  end
end
