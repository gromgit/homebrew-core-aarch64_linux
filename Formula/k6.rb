class K6 < Formula
  desc "Modern load testing tool, using Go and JavaScript"
  homepage "https://k6.io"
  url "https://github.com/grafana/k6/archive/v0.38.1.tar.gz"
  sha256 "d48dc59008cdd565c8362b064889770da11069f75719aa001aeab7dd92f4a1b5"
  license "AGPL-3.0-or-later"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/k6"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "f14de41a958a079da68717735431f8765d9fc2e074d20fc8aa6dc4465233b922"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath/"whatever.js").write <<~EOS
      export default function() {
        console.log("whatever");
      }
    EOS

    assert_match "whatever", shell_output("#{bin}/k6 run whatever.js 2>&1")
    assert_match version.to_s, shell_output("#{bin}/k6 version")
  end
end
