class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://github.com/okteto/okteto/archive/1.10.2.tar.gz"
  sha256 "3ac74548a481d0416c0a46c223800057c5685327462fb34f81bf07d6621b589e"
  license "Apache-2.0"
  head "https://github.com/okteto/okteto.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "011ca604222ebcd2bf74995d678b198be2c247487ebb43d65d8d4bf866e8e852" => :big_sur
    sha256 "e6806a3ba96228f7bbad074a6b4116109a9da5824c5367c5f14ebd55ac2a81aa" => :catalina
    sha256 "8c3dfbc5f3ca152cc903cd0ca62bbfa0211ee931570e9cd553ac3dfa460e780a" => :mojave
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
