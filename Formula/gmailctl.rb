class Gmailctl < Formula
  desc "Declarative configuration for Gmail filters"
  homepage "https://github.com/mbrt/gmailctl"
  url "https://github.com/mbrt/gmailctl/archive/v0.6.0.tar.gz"
  sha256 "e188d5d18ac84ca86c94fb2b90d219ae3bea1e1ddee1966fae904c93bf27f233"

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-s -w -X main.version=#{version}", *std_go_args, "cmd/gmailctl/main.go"
  end

  test do
    assert_includes shell_output("#{bin}/gmailctl init"), "The credentials are not initialized"
  end
end
