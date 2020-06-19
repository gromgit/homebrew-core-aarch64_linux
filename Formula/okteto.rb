class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://github.com/okteto/okteto/archive/1.8.12.tar.gz"
  sha256 "75b76b7519d263db1b3bc85f0114e24d5f0e29744b0aeb349ebdf24fce8306d6"

  bottle do
    cellar :any_skip_relocation
    sha256 "9b69eebf6f1c6265c3263cea3e78976deec86f414deb1dea376ab643e21c2448" => :catalina
    sha256 "c15a8cec83100f58facaa33576a1591367d7969d95e02f044de3a3848adf7159" => :mojave
    sha256 "1d1038f3dd9da34a346a2804849b4e4b963af38d56288286724947296471be94" => :high_sierra
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
