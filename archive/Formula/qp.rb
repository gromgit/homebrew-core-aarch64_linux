class Qp < Formula
  desc "Command-line (ND)JSON querying"
  homepage "https://github.com/f5io/qp"
  url "https://github.com/f5io/qp/archive/1.0.1.tar.gz"
  sha256 "6ef12fd4494262899ee12cc1ac0361ec0dd7b67e29c6ac6899d1df21efc7642b"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/qp"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "b75274c16c0e691e875b17d17ef7ebb6af0773e2b0287888309747880dbce0b3"
  end

  depends_on "quickjs" => :build

  resource "csp-js" do
    url "https://unpkg.com/@paybase/csp@1.0.8/dist/esm/index.js"
    sha256 "d50e6a6d5111a27a5b50c2b173d805a8f680b7ac996aa1c543e7b855ade4681c"
  end

  def install
    mkdir bin.to_s

    resource("csp-js").stage { cp_r "index.js", buildpath/"src/csp.js" }

    system "qjsc",  "-o", "#{bin}/qp",
                          "-fno-proxy",
                          "-fno-eval",
                          "-fno-string-normalize",
                          "-fno-map",
                          "-fno-typedarray",
                          "src/main.js"
  end

  test do
    assert_equal "{\"id\":1}\n", pipe_output("#{bin}/qp 'select id'", "{\"id\": 1, \"name\": \"test\"}")
  end
end
