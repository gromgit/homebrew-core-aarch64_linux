class Inform6 < Formula
  desc "Design system for interactive fiction"
  homepage "https://inform-fiction.org/inform6.html"
  url "https://ifarchive.org/if-archive/infocom/compilers/inform6/source/inform-6.35-r4.tar.gz"
  version "6.35-r4"
  sha256 "05e86a12c0a60b8fb0309986ad50a8efdbcc1afe5feed5497c5dc665f1091cce"
  license "Artistic-2.0"
  head "https://gitlab.com/DavidGriffith/inform6unix.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "5ae97bd7954cb02c476a6857f89aea4e4db36e5f0c41a338826f17d19202b501"
    sha256 cellar: :any_skip_relocation, big_sur:       "ca7929a2f1d6668132135d1ddb8e13161d82144dbfd17709940306dfd60c1888"
    sha256 cellar: :any_skip_relocation, catalina:      "57f41060be7805e2e7a9030b418df06124947a943c0e0b25531807e47f6b936e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8d07e532f56b458abffe2d90b464ddea161e7435647dcfd8b409fb0cfcb47cfd"
  end

  resource "Adventureland.inf" do
    url "https://inform-fiction.org/examples/Adventureland/Adventureland.inf"
    sha256 "3961388ff00b5dfd1ccc1bb0d2a5c01a44af99bdcf763868979fa43ba3393ae7"
  end

  def install
    # Parallel install fails because of: https://gitlab.com/DavidGriffith/inform6unix/-/issues/26
    ENV.deparallelize
    system "make", "PREFIX=#{prefix}", "MAN_PREFIX=#{man}", "MANDIR=#{man1}", "install"
  end

  test do
    resource("Adventureland.inf").stage do
      system "#{bin}/inform", "Adventureland.inf"
      assert_predicate Pathname.pwd/"Adventureland.z5", :exist?
    end
  end
end
