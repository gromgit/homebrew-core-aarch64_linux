class Nuclei < Formula
  desc "HTTP/DNS scanner configurable via YAML templates"
  homepage "https://nuclei.projectdiscovery.io/"
  url "https://github.com/projectdiscovery/nuclei/archive/v2.4.1.tar.gz"
  sha256 "e45ec95b0f9c5d32d7bc75f5a9d6d58ebcfca0c776dda867fffc7c18e91c4e82"
  license "MIT"
  head "https://github.com/projectdiscovery/nuclei.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "706faf964fa58518987d65199e58f7ccf3cd3d3352c620b2022d40c0ac280c19"
    sha256 cellar: :any_skip_relocation, big_sur:       "e44b70f479aeb656608e57715b990d9a1b86df4f072e5120959f457448662cf0"
    sha256 cellar: :any_skip_relocation, catalina:      "69c808b122008847f06a2f98e2a9ea302202f1a4c6b051eb63620fbeb2038917"
    sha256 cellar: :any_skip_relocation, mojave:        "a6827455a294840c24dca0ac0a154c5f927e2fcef4718934793a6c99890e7e14"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "80d19505839db16524ff9e7f2bf60a886c211e63c68080702a6a1a862776d04b"
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
