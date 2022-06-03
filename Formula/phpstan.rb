class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://github.com/phpstan/phpstan"
  url "https://github.com/phpstan/phpstan/releases/download/1.7.10/phpstan.phar"
  sha256 "e9c264ca88a35c0c78674ae6dc786eeb94aebe13144b3d816c0e4e19c5662daf"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e91a40430ac15a2baadf6b3ea444f048f91acc681d8e7cc0cb161a4d35950055"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e91a40430ac15a2baadf6b3ea444f048f91acc681d8e7cc0cb161a4d35950055"
    sha256 cellar: :any_skip_relocation, monterey:       "a02c9229d546df394ad13be772a547bc8c3137c1a3f29968edaf1074b2328e84"
    sha256 cellar: :any_skip_relocation, big_sur:        "a02c9229d546df394ad13be772a547bc8c3137c1a3f29968edaf1074b2328e84"
    sha256 cellar: :any_skip_relocation, catalina:       "a02c9229d546df394ad13be772a547bc8c3137c1a3f29968edaf1074b2328e84"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e91a40430ac15a2baadf6b3ea444f048f91acc681d8e7cc0cb161a4d35950055"
  end

  depends_on "php" => :test

  # Keg-relocation breaks the formula when it replaces `/usr/local` with a non-default prefix
  on_macos do
    pour_bottle? only_if: :default_prefix if Hardware::CPU.intel?
  end

  def install
    bin.install "phpstan.phar" => "phpstan"
  end

  test do
    (testpath/"src/autoload.php").write <<~EOS
      <?php
      spl_autoload_register(
          function($class) {
              static $classes = null;
              if ($classes === null) {
                  $classes = array(
                      'email' => '/Email.php'
                  );
              }
              $cn = strtolower($class);
              if (isset($classes[$cn])) {
                  require __DIR__ . $classes[$cn];
              }
          },
          true,
          false
      );
    EOS

    (testpath/"src/Email.php").write <<~EOS
      <?php
        declare(strict_types=1);

        final class Email
        {
            private string $email;

            private function __construct(string $email)
            {
                $this->ensureIsValidEmail($email);

                $this->email = $email;
            }

            public static function fromString(string $email): self
            {
                return new self($email);
            }

            public function __toString(): string
            {
                return $this->email;
            }

            private function ensureIsValidEmail(string $email): void
            {
                if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
                    throw new InvalidArgumentException(
                        sprintf(
                            '"%s" is not a valid email address',
                            $email
                        )
                    );
                }
            }
        }
    EOS
    assert_match(/^\n \[OK\] No errors/,
      shell_output("#{bin}/phpstan analyse --level max --autoload-file src/autoload.php src/Email.php"))
  end
end
