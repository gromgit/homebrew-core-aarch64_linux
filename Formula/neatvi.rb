class Neatvi < Formula
  desc "Clone of ex/vi for editing bidirectional utf-8 text"
  homepage "https://repo.or.cz/neatvi.git"
  url "https://repo.or.cz/neatvi.git",
      tag:      "10",
      revision: "1a5dcfa46dc0770bfe79f8f3ef2e5990b1fe98b9"
  license "ISC"
  head "https://repo.or.cz/neatvi.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/neatvi"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "90df145fdeeedc2fe960d6f6462f874ad210c849c44b7a8f13102d26a9086933"
  end

  def install
    system "make"
    bin.install "vi" => "neatvi"
  end

  test do
    pipe_output("#{bin}/neatvi", ":q\n")
  end
end
