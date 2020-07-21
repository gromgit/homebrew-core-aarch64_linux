class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://github.com/okteto/okteto/archive/1.8.15.tar.gz"
  sha256 "5a8012a0673fed85eceb6e14690461f2896e85a8d54850d03abe295241cb737e"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "4132a3c465f53c6b9f6d90558348013d94f35007f6e01ff42a0544b66342c51d" => :catalina
    sha256 "c7f572cc6905692aff03c7b24e1af2c8882095c5fa0e690b6361b270a0aefbb9" => :mojave
    sha256 "573f8fc286e80c88d730d1cfe0a8f7954cef3cdebf9714594814bf68bd1bca26" => :high_sierra
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
      forward:
      - 1234:1234
      - 8080:8080
    EOS
    got = File.read("test.yml")
    assert_equal expected, got
  end
end
