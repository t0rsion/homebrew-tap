class HolosTda < Formula
  desc "Vietoris-Rips persistent homology with an implicit ripser-class engine"
  homepage "https://github.com/t0rsion/holos"
  version "0.3.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/t0rsion/holos/releases/download/v0.3.0/holos-tda-aarch64-apple-darwin.tar.xz"
      sha256 "ffddb22ba4d6ce9d22a99c7988d6f22d4472117ed44c861263c618beb7d5de77"
    end
    if Hardware::CPU.intel?
      url "https://github.com/t0rsion/holos/releases/download/v0.3.0/holos-tda-x86_64-apple-darwin.tar.xz"
      sha256 "e6037f5eea3330282921116bc679f08a489bd6a3a5b79296116abc21dc80f219"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/t0rsion/holos/releases/download/v0.3.0/holos-tda-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "61940eaccae6afcfd308071b396c30bfcff34a8aa33990211541f634efcee3f5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/t0rsion/holos/releases/download/v0.3.0/holos-tda-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "bf5254d0adb8c3df4f89b9dedffbcabdc38b1139e2b082f6ea85676a3eccc365"
    end
  end
  license any_of: ["MIT", "Apache-2.0"]

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "holos" if OS.mac? && Hardware::CPU.arm?
    bin.install "holos" if OS.mac? && Hardware::CPU.intel?
    bin.install "holos" if OS.linux? && Hardware::CPU.arm?
    bin.install "holos" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
