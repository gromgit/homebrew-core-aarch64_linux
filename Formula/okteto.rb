class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://github.com/okteto/okteto/archive/1.8.2.tar.gz"
  sha256 "e35d002a6a7a4f2f152f0e9f2181ffddc017fb5415838794e58f51cedbdb15df"

  bottle do
    cellar :any_skip_relocation
    sha256 "edb70c70a3ae55bce54659800d8ae5e1a340be0246e63ac93ab9f44c0fb73d03" => :catalina
    sha256 "777238098b096466c48ec950524d1f1bff6e8f08c359b6598cd686a6b5e75c16" => :mojave
    sha256 "a7bf0f73d72c53794d5f07617f2e046467f2f6330b69b12a3344dcaa66bb68a4" => :high_sierra
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
