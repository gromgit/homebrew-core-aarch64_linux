class Nuclei < Formula
  desc "HTTP/DNS scanner configurable via YAML templates"
  homepage "https://nuclei.projectdiscovery.io/"
  url "https://github.com/projectdiscovery/nuclei/archive/v2.3.6.tar.gz"
  sha256 "c3a530eebe099675a3b6b1e49a87e73a18d156b1979e166fb1df5d7829c9bbb7"
  license "MIT"
  head "https://github.com/projectdiscovery/nuclei.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "00b604baf984876fa13adddfb70590ca37e64c83d78a4eab684aae52d69e5665"
    sha256 cellar: :any_skip_relocation, big_sur:       "8b43cae055b41bcbf4efa8ac97430be10bd492153b246ec1230cc5c2bef5ed58"
    sha256 cellar: :any_skip_relocation, catalina:      "999ce4ed94a9aa6e377078782a2441bda7b2868179f221dc62611ffed8385d30"
    sha256 cellar: :any_skip_relocation, mojave:        "51cce4cc30be90d1e2933c1f84ce9c0a16dc4200548bb1dd6b43a6ea46e738f3"
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
