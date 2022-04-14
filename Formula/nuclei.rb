class Nuclei < Formula
  desc "HTTP/DNS scanner configurable via YAML templates"
  homepage "https://nuclei.projectdiscovery.io/"
  url "https://github.com/projectdiscovery/nuclei/archive/v2.6.7.tar.gz"
  sha256 "a6a02e2daac1eb186c95cd956c9314c0c64139b7054c4066a2cfa0526f0ff82f"
  license "MIT"
  head "https://github.com/projectdiscovery/nuclei.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0d3f8a0236c561b7638d89bcc5000ef522095f4b1148882b636b9048828473e3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9b1633cc382fc2d585383e3504e7565bc695004e29942c2b9a1053acb6cfafb1"
    sha256 cellar: :any_skip_relocation, monterey:       "0376f12311f6fdca9ab14716806c8d2bb0c95fa308aabbae594d24b69888ac98"
    sha256 cellar: :any_skip_relocation, big_sur:        "16cc74ec692c4771b557824e0bc56da92284cdcd279f820651989609b2b82561"
    sha256 cellar: :any_skip_relocation, catalina:       "d2d41f2aa5a502f62dbb2a0afd9b6eb1c4fae2d7536f5331f55735651353aaf6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0c6388f585d5967575a51fa1202192e620b4aa08b4ce6d749019ec685ecf744b"
  end

  depends_on "go" => :build

  def install
    cd "v2/cmd/nuclei" do
      system "go", "build", *std_go_args, "main.go"
    end
  end

  test do
    (testpath/"test.yaml").write <<~EOS
      id: homebrew-test

      info:
        name: Homebrew test
        author: bleepnetworks
        severity: INFO
        description: Check DNS functionality

      dns:
        - name: \"{{FQDN}}\"
          type: A
          class: inet
          recursion: true
          retries: 3
          matchers:
            - type: word
              words:
                - \"IN\tA\"
    EOS
    system "nuclei", "-target", "google.com", "-t", "test.yaml"
  end
end
