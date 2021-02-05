class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://github.com/okteto/okteto/archive/1.10.6.tar.gz"
  sha256 "23ad154a403f544d400935a21158e27d16895144288325c94ec15e0ab32a5a4c"
  license "Apache-2.0"
  head "https://github.com/okteto/okteto.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "3bc13e898b4167d2605db02214817b70c4a7aea4a46b8771ffe54efdf3ccfc74"
    sha256 cellar: :any_skip_relocation, big_sur:       "527aefc2f5e46d8ecc249e940a77a5a2117c8d4405c8c36345b56d5630889067"
    sha256 cellar: :any_skip_relocation, catalina:      "f25b493927fab5440ad7024504b4e0c7b28b7b5cf232f055cde2106221bfcf17"
    sha256 cellar: :any_skip_relocation, mojave:        "89c652339d693c0e93a17a59e687ec9dab2cc1b4f1ccad7a6dd9412380d096f4"
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
