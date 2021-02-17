class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://github.com/okteto/okteto/archive/1.10.7.tar.gz"
  sha256 "4246c5ecfd2640c301fe160bda56d3ac38854de92fa26efdf2885cb99ba63e0b"
  license "Apache-2.0"
  head "https://github.com/okteto/okteto.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "df71c64d05fa6d2dd256505360e6f12d05639c0108b255ba7ab474e89474f397"
    sha256 cellar: :any_skip_relocation, big_sur:       "3bdbf590ab710027c13dd5e89a4f3a96a488a222aee993c2524f9d932b6065b0"
    sha256 cellar: :any_skip_relocation, catalina:      "2cce92415bf0c3b9f6931d7a38c3ec0421b96f55bdffb97a6febc82e2317774f"
    sha256 cellar: :any_skip_relocation, mojave:        "3450f696c18055eb70f01a7adf4af51665e37f82e47f9ce4d7a57ca5826bffb9"
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
