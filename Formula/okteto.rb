class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://github.com/okteto/okteto/archive/1.8.4.tar.gz"
  sha256 "fc3629699355e7ab66661d5c77d34eb8b75ba8cb1ed8beaad74a5ab88a211ec6"

  bottle do
    cellar :any_skip_relocation
    sha256 "6214cce60c4bf1c7502e26d878cfbbda828b20822eec7c5ab86eca4a1424ba92" => :catalina
    sha256 "3fbda2bb60bccdb9a89f7225bdcf0c4ff3b9461e3d2a879c3cdae96026711add" => :mojave
    sha256 "b8b19f5f9a7d244874e5ddae4bf6836b41f389fc1062773a8697906bb98897ed" => :high_sierra
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
      workdir: /usr/src/app
    EOS
    got = File.read("test.yml")
    assert_equal expected, got
  end
end
