class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://github.com/okteto/okteto/archive/1.10.3.tar.gz"
  sha256 "ec61e04d0ca746a24e9f6ec1819e39e277cbb141c53c0ea17b8ba1bae7e653a3"
  license "Apache-2.0"
  head "https://github.com/okteto/okteto.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "acbcae326a7506e3aa5d0d6e2cdbcb133bc8c21eb871b79de27945e0345658fd" => :big_sur
    sha256 "a283c7e04ddc4f199ea97079046df214c30b1dae7baa345af65eefedffbc74bc" => :catalina
    sha256 "ce34984927d0403227b5a4e82d8c3f112a3d216c67775a3623235b24fc4c3830" => :mojave
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/okteto/okteto/pkg/config.VersionString=#{version}"
    tags = "osusergo netgo static_build"
    system "go", "build", *std_go_args, "-ldflags", ldflags, "-tags", tags
  end

  test do
    touch "test.rb"
    system "echo | okteto init --overwrite --file test.yml"
    expected = <<~EOS
      name: #{Pathname.getwd.basename}
      image: okteto/ruby:2
      command: bash
      sync:
      - .:/usr/src/app
      forward:
      - 1234:1234
      - 8080:8080
      persistentVolume: {}
    EOS
    got = File.read("test.yml")
    assert_equal expected, got
  end
end
