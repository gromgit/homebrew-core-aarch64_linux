class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      tag:      "v0.151.2",
      revision: "ea83297e735fc0c677b3de1b7875f0d35f26fa95"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "86786705b58ae0fbf1973785e0eb6cf23618ab48c85b2b3bd87f0bf28d4bcc6f" => :big_sur
    sha256 "215023226365ba0dc6f2d62fbfdb80e50c7eb07eb22b1b09b0dceeda4364e42b" => :arm64_big_sur
    sha256 "a0c80867d37628f72d243792bba9f76f3966467f388e5b976470bc65ea417e35" => :catalina
    sha256 "4dc4f7db2ec229c98da49dd2ab642b07c6f152259f081bd56ed060f4876af52a" => :mojave
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags",
             "-s -w -X main.version=#{version} -X main.commit=#{stable.specs[:revision]} -X main.builtBy=homebrew",
             *std_go_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/goreleaser -v 2>&1")
    assert_match "config created", shell_output("#{bin}/goreleaser init --config=.goreleaser.yml 2>&1")
    assert_predicate testpath/".goreleaser.yml", :exist?
  end
end
